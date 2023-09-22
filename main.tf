
# Fetch public IP address for your local machine to allow SSH access
resource "null_resource" "fetch_public_ip" {
  provisioner "local-exec" {
    command = "curl -s ifconfig.co/json > public_ip.json"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_instance" "lotus-lab_instance" {
  #ami = "ami-0b69ea66ff7391e80" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  ami = "ami-0261755bbcb8c4a84" # Ubuntu 20.04 AMI (HVM), SSD Volume Type
  instance_type = "g2.2xlarge"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.lotus-lab_sg.id]
  subnet_id = aws_subnet.lotus-lab_subnet.id
  availability_zone = "us-east-1a"
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 2048
  }
  provisioner "file" {
    source      = "prepare_lotus.sh"
    destination = "/tmp/setup_lotus_node.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_lotus_node.sh",
      "/tmp/setup_lotus_node.sh ${var.calibrationsnap}"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
  tags = {
    Name = "lotus-lab-instance"
  }
}

output "lotus-lab_public_ip" {
  value = aws_instance.lotus-lab_instance.public_ip
}
