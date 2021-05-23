## Terraform templated for Kubernetes on AWS, GCP, and Azure
### AWS
* provider.tf
  * declare these scripts run on AWS
* vpc.tf
  * define virtual private cloud
* subnet.tf
  * define public and private subnets and gateways
* cluster.tf
  * set up k8s control plane
* node_group.tf
  * run pods/containers on EC2
* addon.tf
  * set CNI (container network interface) up, not to use proxy/nat
* iam_role.tf
  * assign roles to cluster and node group to let them access and control components in VPC
* security_group.tf
  * two security groups are defined, but not used yet.
* variable.tf
  * Now only one variable: a designated IP that is used in a security_group. Not used yet as well as the security groups
### GCP
Coming soon. Probably easier than AWS.
### Azure
Coming soon. Probably easier than AWS.