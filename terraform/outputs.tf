##################################################
# Outputs for EKS, Networking & Web Server
##################################################

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.this.name
}

output "eks_cluster_endpoint" {
  description = "EKS API Endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "node_group_name" {
  description = "EKS Node Group Name"
  value       = aws_eks_node_group.this.node_group_name
}

output "webserver_lb_dns" {
  value = "Run: kubectl get svc webserver-service -n webserver -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
