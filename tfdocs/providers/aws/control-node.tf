resource "aws_key_pair" "proxycannon-key" {
  key_name   = "proxycannon-key"
  public_key = var.public_key
}

resource "aws_instance" "command-node" {
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.image_id
  instance_type = var.control_instance_type
  
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.proxycannon-command-group.id]
  subnet_id = module.proxycannon-vpc.public_subnets[0] # TODO make this dynamic
  
  key_name = aws_key_pair.proxycannon-key.key_name
  source_dest_check = false

  # TODO make this dynamic in case a user does not want spot instances
  instance_market_options {
    market_type = "spot"
  }

  # TODO variabilize this if the user is okay with unlimited credit spiking
  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "cannon-command"
  }

  depends_on = [
    aws_instance.exit-node,
  ]

  provisioner "file" {
    source = "${path.root}/tfdocs/configs/command/"
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
    command = "scp -i ${var.key-file} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${self.public_ip}:/tmp/conpack.tar.gz ${path.root}/"
  }
}
