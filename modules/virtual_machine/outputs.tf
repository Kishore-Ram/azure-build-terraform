output "jumpbox_public_ip" {
  value = module.vm.public_ip
}
output "jumpbox_ssh_command" {
  value = module.vm.ssh_command
}