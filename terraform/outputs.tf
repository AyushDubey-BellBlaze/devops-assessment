output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.app_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2"
  value       = aws_instance.app_server.public_dns
}
/*
output "backend_ecr_url" {
  value = aws_ecr_repository.backend_repo.repository_url
}

output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend_repo.repository_url
} */