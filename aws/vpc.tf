resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"

  # needed to register nodes in the cluster
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "eks"
  }
}
