resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.eks_private[*].id

  ami_type        = "AL2_x86_64"
  disk_size       = "20"
  instance_types  = ["t3.medium"]

  remote_access {
    ec2_ssh_key               = "eks"
  }
  
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  
  depends_on = [
    aws_eks_addon.eks_vpc_cni,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}
