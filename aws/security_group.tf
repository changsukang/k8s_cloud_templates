resource "aws_security_group" "allow_external_ssh" {
  name        = "allow-external-ssh"
  description = "Allow external SSH traffic"
  vpc_id      = aws_vpc.eks.id

  ingress {
    description      = "allow ssh from public IPs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.designated_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-external-ssh"
  }
}

resource "aws_security_group" "allow_internal_ssh" {
  name        = "allow-internal-ssh"
  description = "Allow internal SSH traffic"
  vpc_id      = aws_vpc.eks.id

  ingress {
    description      = "allow ssh from private IPs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.eks.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-internal-ssh"
  }
}
