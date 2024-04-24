resource "aws_instance" "command-node" {
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.image_id
  instance_type = var.control_instance_type
  vpc_security_group_ids = [aws_security_group.proxycannon-command-group.id]
  key_name = var.sshName
  source_dest_check = false

  tags = {
    Name = "cannon-command"
  }

  depends_on = [
    aws_instance.exit-node,
  ]

  provisioner "file" {
    source = "${path.module}/configs/command/"
    destination = "/tmp"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.key-file)
      host = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/command_setup.bash",
      "sudo /tmp/command_setup.bash 2",
      "sudo chmod +x /tmp/add_route.bash",
      "cat /tmp/node_addresses.txt | while read line; do sudo /tmp/add_route.bash $line; done",
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.key-file)
      host = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "scp -i ${var.key-file} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${self.public_ip}:/tmp/conpack.tar.gz ${path.module}/"
  }
}
