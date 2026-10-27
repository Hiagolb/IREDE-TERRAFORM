# variables.tf
# Declara as variáveis de entrada do projeto.

variable "aws_region" {
  description = "Região AWS onde a infraestrutura será provisionada."
  type        = string
  default     = "sa-east-1"
}

variable "project_name" {
  description = "Prefixo usado no nome (tag Name) de todos os recursos."
  type        = string
  default     = "irede-mvp-1"

  validation {
    condition     = length(var.project_name) > 0
    error_message = "O project_name não pode ser vazio."
  }
}

variable "vpc_cidr" {
  description = "CIDR block da VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr deve ser um CIDR IPv4 válido (ex.: 10.0.0.0/16)."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block da sub-rede pública."
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr))
    error_message = "public_subnet_cidr deve ser um CIDR IPv4 válido (ex.: 10.0.1.0/24)."
  }
}

variable "private_subnet_1_cidr" {
  description = "CIDR block da sub-rede privada 1."
  type        = string
  default     = "10.0.2.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_1_cidr))
    error_message = "private_subnet_1_cidr deve ser um CIDR IPv4 válido (ex.: 10.0.2.0/24)."
  }
}

variable "private_subnet_2_cidr" {
  description = "CIDR block da sub-rede privada 2."
  type        = string
  default     = "10.0.3.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_2_cidr))
    error_message = "private_subnet_2_cidr deve ser um CIDR IPv4 válido (ex.: 10.0.3.0/24)."
  }

  # Verificação única de que os três CIDRs de sub-rede são distintos.
  # Centralizada aqui para evitar dependência circular entre validações
  # (variáveis não podem se referenciar mutuamente em seus blocks de validação).
  validation {
    condition     = var.public_subnet_cidr != var.private_subnet_1_cidr && var.public_subnet_cidr != var.private_subnet_2_cidr && var.private_subnet_1_cidr != var.private_subnet_2_cidr
    error_message = "Os CIDRs das três sub-redes não podem ser iguais entre si."
  }
}
