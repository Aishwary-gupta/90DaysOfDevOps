output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Web security group ID"
  value       = aws_security_group.web.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "instance_private_ip" {
  description = "EC2 private IP"
  value       = aws_instance.web.private_ip
}