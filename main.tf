# main.tf
# Declara a VPC, as três sub-redes, o Internet Gateway, a tabela de rotas
# pública, a rota padrão para a Internet e a associação da tabela de rotas
# à sub-rede pública.
#
# As sub-redes privadas NÃO são associadas a nenhuma tabela de rotas
# customizada: por padrão, elas usam a tabela de rotas principal (main route
# table) criada automaticamente pela VPC, que contém apenas a rota local.
# Portanto, permanecem isoladas da Internet, sem NAT Gateway.

# Data source: zonas de disponibilidade disponíveis na região escolhida.
# Usado para distribuir as sub-redes entre AZs distintas quando possível.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Tags comuns reutilizáveis, aplicadas a todos os recursos via merge().
  common_tags = {
    MVP = "MVP1"
  }

  # Lista de zonas de disponibilidade disponíveis na região.
  # sa-east-1 possui 3 AZs (sa-east-1a, sa-east-1b, sa-east-1c).
  azs = data.aws_availability_zones.available.names
}

# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# ---------------------------------------------------------------------------
# Sub-rede pública
# map_public_ip_on_launch = true  -> atribui IPv4 público automaticamente.
# ---------------------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = local.azs[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-public"
  })
}

# ---------------------------------------------------------------------------
# Sub-rede privada 1
# map_public_ip_on_launch = false -> sem IPv4 público automático.
# ---------------------------------------------------------------------------
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = local.azs[1]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-private-1"
  })
}

# ---------------------------------------------------------------------------
# Sub-rede privada 2
# Usa a 3ª zona disponível quando houver (ex.: sa-east-1c). Caso a região
# tenha apenas 2 AZs, reutiliza a 1ª zona (2 % length == 0), mantendo ao
# menos 2 zonas distintas no total.
# ---------------------------------------------------------------------------
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_2_cidr
  availability_zone       = local.azs[2 % length(local.azs)]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-private-2"
  })
}

# ---------------------------------------------------------------------------
# Internet Gateway anexado à VPC
# ---------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# ---------------------------------------------------------------------------
# Tabela de rotas pública
# ---------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rtb-public"
  })
}

# ---------------------------------------------------------------------------
# Rota padrão 0.0.0.0/0 apontando para o Internet Gateway.
# Apenas a tabela de rotas pública possui esta rota.
# ---------------------------------------------------------------------------
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# ---------------------------------------------------------------------------
# Associação da tabela de rotas pública à sub-rede pública.
# As sub-redes privadas não recebem associação e seguem usando a main route
# table da VPC (apenas rota local), permanecendo isoladas.
# ---------------------------------------------------------------------------
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
