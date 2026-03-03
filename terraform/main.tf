provider "aws" {
  region = "ap-south-1"
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "app_sg" {
  name = "devops-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# IAM Role for EC2
# -------------------------
resource "aws_iam_role" "ec2_role" {
  name = "ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# -------------------------
# EC2 Instance
# -------------------------
resource "aws_instance" "app_server" {
  ami           = "ami-002dc43e5c8f29c3e"   # apne region ka Ubuntu AMI daalna
  instance_type = "t2.micro"

  security_groups = [aws_security_group.app_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install docker.io -y
systemctl start docker
systemctl enable docker
EOF

  tags = {
    Name = "devops-ec2"
  }
}