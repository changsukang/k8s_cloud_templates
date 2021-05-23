resource "aws_eks_addon" "eks_vpc_cni" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "vpc-cni"
}
