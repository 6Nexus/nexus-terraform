resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"] 
    description = "Allow internal communication on port 8080"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"] 
    description = "Allow internal MySQL communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = var.sg_group_name
  }
}

resource "aws_key_pair" "generated_key"{
  key_name   = var.key_name
  public_key = file("id_rsa.pem.pub")
}

resource "aws_instance" "public_ec2" {
  ami           = var.ami_id  
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  key_name      = aws_key_pair.generated_key.key_name

  user_data = <<-EOF
            #!/bin/bash
            apt update -y
            git clone https://github.com/6Nexus/nexus-script-instalacao.git /home/ubuntu/script
            git clone https://github.com/6Nexus/nexus-frontend.git /home/ubuntu/app
            cd /home/ubuntu/app/nexus-frontend
            git checkout teste-infra
         
          EOF

  tags = {
    Name = var.public_ec2_name
  }
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.public_ec2.id
}

resource "aws_instance" "private_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  key_name      = aws_key_pair.generated_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              git clone https://github.com/6Nexus/nexus-script-instalacao.git /home/ubuntu/script

              git clone https://github.com/6Nexus/nexus-api.git /home/ubuntu/api
              cd /home/ubuntu/api
              git checkout teste-infra
            EOF

  tags = {
    Name = var.private_ec2_name
  }
}

resource "aws_instance" "private_ec2_b" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  key_name      = aws_key_pair.generated_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              git clone https://github.com/6Nexus/nexus-script-instalacao.git /home/ubuntu/script

              git clone https://github.com/6Nexus/nexus-api.git /home/ubuntu/api
              cd /home/ubuntu/api
              git checkout teste-infra
            EOF

  tags = {
    Name = "private-ec2-b"
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size             = var.size

  tags = {
    Name = var.ebs_volume_name
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.volume.id
  instance_id = aws_instance.public_ec2.id
}