resource "aws_instance" "exit-node" {
  count = var.server_count
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.image_id
  instance_type = var.exit_instance_type
  
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.proxycannon-exit-group.id]
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
    Name = "cannon-exit${count.index}"
  }

  user_data = file("${path.root}/tfdocs/configs/node/node_setup.bash")

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ${path.root}/tfdocs/configs/command/node_addresses.txt"
  }
}