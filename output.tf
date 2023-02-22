output "PublicIP" {
  value = oci_core_instance.vm.*.public_ip
}

