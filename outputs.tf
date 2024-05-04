output "aws_instance_public_ip" {
  value = aws_instance.terraform_instance.public_ip
}

output "aws_instance_id" {
  value = aws_instance.terraform_instance.id
}