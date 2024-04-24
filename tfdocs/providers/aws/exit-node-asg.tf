resource "aws_instance" "exit-node" {
  count = var.server_count
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.image_id
  instance_type = var.exit_instance_type
  vpc_security_group_ids = [aws_security_group.proxycannon-exit-group.id]
  key_name = var.sshName
  source_dest_check = false

  tags = {
    Name = "cannon-exit${count.index}"
  }

  user_data = file("${path.root}/tfdocs/configs/node/node_setup.bash")

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ${path.module}/configs/command/node_addresses.txt"
  }
}