resource "aws_eks_cluster" "eks" {
  name     = "eks"
  version  = "1.20"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids          = concat(aws_subnet.eks_private[*].id, aws_subnet.eks_public[*].id)
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  depends_on = [
    aws_cloudwatch_log_group.eks,
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly    
  ]
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/eks/cluster"
  retention_in_days = 7
}

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}
