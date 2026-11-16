output "vpc_id" {
  description = "ID of the project VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security group attached to the Kubernetes nodes."
  value       = aws_security_group.nodes.id
}

output "node_details" {
  description = "Public and private addresses of the three EC2 nodes."
  value = {
    for name, instance in aws_instance.kubernetes_node : name => {
      instance_id = instance.id
      public_ip   = instance.public_ip
      private_ip  = instance.private_ip
    }
  }
}
