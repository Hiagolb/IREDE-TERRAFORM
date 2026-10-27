# IREDE-MVP1 — Infraestrutura de Rede na AWS com Terraform

Projeto Terraform que cria uma VPC com três sub-redes (uma pública e duas
privadas), um Internet Gateway e a tabela de rotas pública associada à
sub-rede pública. As sub-redes privadas permanecem isoladas, sem rota para
a Internet e sem NAT Gateway.

Desenvolvido para a Trilha Cloud — Atividade Prática 03.

## Recursos criados

| Recurso                  | Descrição                                                        |
|--------------------------|------------------------------------------------------------------|
| `aws_vpc`                | VPC `10.0.0.0/16` com DNS support e DNS hostnames habilitados.   |
| `aws_subnet` (public)    | Sub-rede pública `10.0.1.0/24` com IPv4 público automático.      |
| `aws_subnet` (private_1) | Sub-rede privada `10.0.2.0/24` sem IPv4 público.                 |
| `aws_subnet` (private_2) | Sub-rede privada `10.0.3.0/24` sem IPv4 público.                 |
| `aws_internet_gateway`   | Internet Gateway anexado à VPC.                                  |
| `aws_route_table`         | Tabela de rotas pública com rota `0.0.0.0/0` -> IGW.             |
| `aws_route`               | Rota padrão `0.0.0.0/0` apontando para o Internet Gateway.       |
| `aws_route_table_association` | Associação da tabela pública à sub-rede pública.             |

As sub-redes privadas usam a tabela de rotas principal (main route table)
da VPC, que contém apenas a rota local — portanto, sem acesso à Internet.

## Organização dos arquivos

- `versions.tf` — versão mínima do Terraform e versão do provider AWS.
- `providers.tf` — configuração do provider AWS (região por variável, sem credenciais).
- `main.tf` — VPC, sub-redes, Internet Gateway, tabela de rotas, rota e associação.
- `variables.tf` — variáveis de entrada (região, CIDRs, prefixo de nomes).
- `outputs.tf` — outputs com os IDs dos recursos criados.
- `terraform.tfvars.example` — exemplo de valores (sem credenciais).
- `RELATORIO.md` — modelo de relatório de ajustes da equipe.
- `ROTEIRO-APRESENTACAO.md` — roteiro de apresentação.

## Pré-requisitos

- Terraform >= 1.5.0 instalado (https://developer.hashicorp.com/terraform/downloads).
- AWS CLI configurado (`aws configure`) ou credenciais exportadas no ambiente.
- Região padrão: `sa-east-1` (São Paulo). Pode ser alterada via variável.

## Comandos de validação

Execute todos os comandos dentro da pasta do projeto.

### 1. Inicializar o diretório de trabalho (baixa o provider AWS)

```bash
terraform init
```

### 2. Verificar formatação (modo checagem, não altera arquivos)

```bash
terraform fmt -check
```

Se houver arquivos mal formatados, corrija com:

```bash
terraform fmt
```

### 3. Validar a sintaxe e a consistência da configuração

```bash
terraform validate
```

### 4. Planejar o provisionamento (requer credenciais AWS válidas)

```bash
terraform plan
```

> O `plan` apenas **simula** a criação dos recursos e exibe o que seria
> alterado. Nenhum recurso é provisionado nesta etapa.

## Provisionamento (somente com autorização)

> ⚠️ O provisionamento real (`terraform apply`) **só deve ser executado com
> autorização do professor**. Revise o plano antes de aplicar.

Caso autorizado:

```bash
# Revisar o plano detalhado
terraform plan -out=tfplan

# Aplicar o plano previamente revisado
terraform apply tfplan
```

## Remoção dos recursos (importante para evitar custos)

Após a apresentação, remova tudo que foi criado:

```bash
terraform destroy
```

## Segurança e prevenção de custos

- Nenhuma credencial é armazenada no código.
- Não há NAT Gateway, Elastic IP, instâncias EC2 ou outros recursos que
  gerem custos contínuos além da própria VPC (que é gratuita) e do tráfego.
- Use `terraform destroy` ao final para garantir que nenhum recurso continue
  ativo na conta AWS.
