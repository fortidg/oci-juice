// OCI configuration
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "compartment_ocid" {}
variable "region" {
  default = "us-ashburn-1"
}


variable "ubu-image" {
  default = "ocid1.image.oc1.iad.aaaaaaaa65w7hi5ph6gnddni5i6xijrpwinihowqerkasdsaslxo376ris2q"
}

variable "my_ip" {
  type    = string
}

// Environment configuration
variable "vcn_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.1.0.0/24"
}

variable "instance_shape" {
  type    = string
  default = "VM.Standard1.2"
}

# Choose an Availability Domain (1,2,3)
variable "availability_domain" {
  type    = string
  default = "1"
}

variable "volume_size" {
  type    = string
  default = "50" //GB; you can modify this, can't less than 50
}

variable "ssh_public_key_file" {
  default = "/home/ubuntu/.ssh/ssh-key-2022-12-15.key.pub"
}

