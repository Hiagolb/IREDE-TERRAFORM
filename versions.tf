# versions.tf
# Define a versão mínima do Terraform e a versão do provider AWS.
# As restrições de versão garantem reprodutibilidade e compatibilidade.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
