# outputs.tf
# Exibe os IDs dos recursos criados após o `terraform apply`.

output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID da sub-rede pública."
  value       = aws_subnet.public.id
}

output "private_subnet_1_id" {
  description = "ID da sub-rede privada 1."
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "ID da sub-rede privada 2."
  value       = aws_subnet.private_2.id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID da tabela de rotas pública."
  value       = aws_route_table.public.id
}
