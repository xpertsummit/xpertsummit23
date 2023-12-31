output "vm" {
  value = {
    vm_id      = aws_instance.vm.id
    adminuser  = "ubuntu"
    private_ip = aws_instance.vm.private_ip 
    public_ip  = var.public_ip ? aws_instance.vm.public_ip : ""
  }
}