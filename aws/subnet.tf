data "aws_availability_zones" "eks" {
  state = "available"
}

resource "aws_subnet" "eks_public" {
  count = length(data.aws_availability_zones.eks.names)

  vpc_id     = aws_vpc.eks.id
  availability_zone = data.aws_availability_zones.eks.names[count.index]
  cidr_block = format("10.0.%d.0/24", count.index)
  
  tags = {
    Name = format("eks-public-%d", count.index)
  }
}

resource "aws_subnet" "eks_private" {
  count = length(data.aws_availability_zones.eks.names)

  vpc_id     = aws_vpc.eks.id
  availability_zone = data.aws_availability_zones.eks.names[count.index]
  cidr_block = format("10.0.10%d.0/24", count.index)
  
  tags = {
    Name = format("eks-private-%d", count.index)
  }
}

resource "aws_eip" "eks" {
  count = length(data.aws_availability_zones.eks.names)
  vpc   = true
}

resource "aws_nat_gateway" "eks" {
  count = length(data.aws_availability_zones.eks.names)
  
  allocation_id = aws_eip.eks[count.index].id
  subnet_id     = aws_subnet.eks_public[count.index].id

  tags = {
    Name = format("eks-%d", count.index)
  }
}

resource "aws_route_table" "eks_private" {
  count = length(data.aws_availability_zones.eks.names)

  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks[count.index].id
  }

  tags = {
    Name = format("eks-private-%d", count.index)
  }
}

resource "aws_route_table_association" "eks_private" {
  count = length(data.aws_availability_zones.eks.names)
  
  subnet_id      = aws_subnet.eks_private[count.index].id
  route_table_id = aws_route_table.eks_private[count.index].id
}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "eks"
  }
}

resource "aws_route_table" "eks_public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }

  tags = {
    Name = "eks-public"
  }
}

resource "aws_route_table_association" "eks_public" {
  count = length(data.aws_availability_zones.eks.names)
  
  subnet_id      = aws_subnet.eks_public[count.index].id
  route_table_id = aws_route_table.eks_public.id
}
