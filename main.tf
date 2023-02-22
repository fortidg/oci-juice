####################################
## VCN SETTINGS                   ##
####################################


resource "oci_core_virtual_network" "my_vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "tf-juice-vcn"
  dns_label      = "tfjuicevcn"
}


####################################
## PUBLIC NETWORK SETTINGS       ##
###################################
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "juice-igw"
  vcn_id         = oci_core_virtual_network.my_vcn.id
}

resource "oci_core_route_table" "public_routetable" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.my_vcn.id
  display_name   = "juice-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}
resource "oci_core_subnet" "public_subnet" {
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
  cidr_block          = var.public_subnet_cidr
  display_name        = "juice-public"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.my_vcn.id
  route_table_id      = oci_core_route_table.public_routetable.id
  security_list_ids   = ["${oci_core_virtual_network.my_vcn.default_security_list_id}", "${oci_core_security_list.public_security_list.id}"]
  dhcp_options_id     = oci_core_virtual_network.my_vcn.default_dhcp_options_id
  dns_label           = "juicepublic"
}

resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.my_vcn.id
  display_name   = "juice-public-security-list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  // allow inbound http (port 80) traffic
  ingress_security_rules {
    protocol = "6" // tcp
    source   = var.my_ip

    tcp_options {
      min = 3000
      max = 3000
    }
  }
 
  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}




// create ubuntu instance
resource "oci_core_instance" "vm" {
  depends_on          = [oci_core_internet_gateway.igw]
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "ubu-juice-vm"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    display_name     = "juice-vnic-untrust"
    assign_public_ip = true
    hostname_label   = "juice-vnic-untrust"
  }

  launch_options {
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_type             = "image"
    source_id               = var.ubu-image
    boot_volume_size_in_gbs = "50"
  }

  // Required for bootstrapp
  // Commnet out the following if you use the feature.
  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(file("./boot.sh"))}"
  }
}
