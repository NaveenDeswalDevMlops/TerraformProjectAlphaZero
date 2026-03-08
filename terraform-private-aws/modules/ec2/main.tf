data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.name}-ec2-sg"
  description = "Restrictive SG for private EC2"
  vpc_id      = var.vpc_id

  # No ingress blocks are defined: no inbound connections are allowed.
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "HTTPS to private AWS endpoints inside VPC"
  }

  tags = var.tags
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = var.iam_instance_profile_name

  associate_public_ip_address = false

  tags = merge(var.tags, {
    Name = "${var.name}-private-ec2"
  })
}
