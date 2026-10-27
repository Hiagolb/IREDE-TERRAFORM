# Relatório de Ajustes — IREDE-MVP1

Atividade Prática 03 — Trilha Cloud.

Este relatório registra os ajustes e correções realizados pela equipe durante
a elaboração e a validação local do projeto Terraform. Os ajustes abaixo são
reais e foram identificados a partir da execução dos comandos de validação.

## Identificação do projeto

- **Projeto:** IREDE-MVP1
- **Objetivo:** VPC `10.0.0.0/16` com 1 sub-rede pública e 2 privadas,
  Internet Gateway e tabela de rotas pública (sub-redes privadas isoladas).
- **Região padrão:** `sa-east-1`
- **Prefixo de nomes (Name):** `irede-mvp-1`

## Ambiente de validação

- Terraform: v1.17.0 (Windows)
- Provider AWS: hashicorp/aws v5.100.0 (instalado via `terraform init`)
- Região-alvo: `sa-east-1`

## Resultados dos comandos de validação

| Comando               | Resultado | Observação                                              |
|-----------------------|-----------|---------------------------------------------------------|
| `terraform init`      | OK        | Provider AWS v5.100.0 baixado; lock file gerado.        |
| `terraform fmt -check`| OK (0)    | Nenhum arquivo necessitou correção de formatação.       |
| `terraform validate`  | OK (0)    | Configuração válida.                                    |
| `terraform plan`      | Não executado | Nenhum provisionamento realizado; requer credenciais AWS autorizadas. |
| `terraform apply`     | Não executado | Proibido sem autorização do professor.                |
| `terraform destroy`   | Não executado | Sem recursos provisionados a destruir.                |

Nenhum recurso AWS foi provisionado. Apenas as validações locais foram executadas.

## Ajustes e correções realizados

### Ajuste 1 — Ciclo de dependência entre validações de variáveis

- **Arquivo:** `variables.tf`
- **Problema:** as três variáveis de CIDR de sub-rede
  (`public_subnet_cidr`, `private_subnet_1_cidr`, `private_subnet_2_cidr`)
  possuíam blocos `validation` que referenciavam umas às outras, formando um
  ciclo de dependência. O `terraform validate` falhava com
  `Error: Cycle: var.public_subnet_cidr (validation) ...`.
- **Correção:** centralizou-se a verificação de que os três CIDRs são distintos
  em um único bloco de validação (na variável `private_subnet_2_cidr`),
  evitando a referência mútua. Além disso, foram adicionadas validações de
  formato de CIDR IPv4 usando a função `can(cidrnetmask(...))` em cada
  variável de CIDR.

### Ajuste 2 — Atributo incorreto do data source de zonas

- **Arquivo:** `main.tf`
- **Problema:** o local `azs` referenciava
  `data.aws_availability_zones.available.zone_names`, atributo inexistente.
  O `terraform validate` falhava com
  `Error: Unsupported attribute ... no argument, nested block, or exported
  attribute named "zone_names"`.
- **Correção:** o atributo correto do data source é `names`. Atribuído
  `azs = data.aws_availability_zones.available.names`.

## Itens sem ajuste (atendeu diretamente aos requisitos)

- VPC com `enable_dns_support` e `enable_dns_hostnames` habilitados.
- Sub-rede pública com `map_public_ip_on_launch = true`.
- Sub-redes privadas com `map_public_ip_on_launch = false`.
- Internet Gateway anexado à VPC.
- Tabela de rotas pública com rota `0.0.0.0/0` -> IGW e associação à sub-rede pública.
- Sub-redes privadas sem associação a tabela customizada (usam a main route table).
- Tags `Name = irede-mvp-1-<id>` e `MVP = MVP1` em todos os recursos que suportam tags.
- Local `common_tags` reutilizável aplicado via `merge()`.
- Ausência de NAT Gateway, Elastic IP, EC2 e recursos fora do escopo.
- Ausência de credenciais no código.

## Modelo para registros futuros

A equipe pode replicar a tabela abaixo para registrar novos ajustes durante
ensaios ou revisões adicionais:

| Data | Responsável | Arquivo | Problema | Correção | Status |
|------|-------------|---------|----------|----------|--------|
|      |             |         |          |          |        |

## Assinatura da equipe

Preencher com os integrantes:

- Integrante 1: ____________________
- Integrante 2: ____________________
- Integrante 3: ____________________
- Integrante 4: ____________________
