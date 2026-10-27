# Roteiro de Apresentação — IREDE-MVP1

Atividade Prática 03 — Trilha Cloud.

Duração estimada: 7 a 9 minutos.
Ajustar nomes e número de integrantes conforme a equipe (modelo com 4
integrantes; se houver menos, redistribuir os blocos).

---

## Bloco 1 — Objetivo da infraestrutura (1 min) — Integrante 1

- Criar uma VPC `10.0.0.0/16` na região `sa-east-1`.
- Três sub-redes: 1 pública (`10.0.1.0/24`) e 2 privadas (`10.0.2.0/24` e
  `10.0.3.0/24`).
- Sub-rede pública com acesso à Internet via Internet Gateway.
- Sub-redes privadas isoladas, sem rota para a Internet e sem NAT Gateway.
- Projeto simples, econômico e adequado para apresentação acadêmica.

## Bloco 2 — Organização dos arquivos Terraform (1,5 min) — Integrante 2

- `versions.tf` — versões do Terraform e do provider AWS.
- `providers.tf` — provider AWS com região por variável, sem credenciais no código.
- `main.tf` — recursos de rede (VPC, sub-redes, IGW, rotas).
- `variables.tf` — variáveis reutilizáveis (região, CIDRs, prefixo).
- `outputs.tf` — IDs dos recursos criados.
- `terraform.tfvars.example` — exemplo de valores, sem segredos.
- Explicar a separação de responsabilidades entre os arquivos.

## Bloco 3 — CIDRs e zonas de disponibilidade (1,5 min) — Integrante 3

- VPC `10.0.0.0/16`; sub-redes `/24` consecutivas, sem sobreposição.
- Validações em `variables.tf` impedem CIDRs iguais entre as sub-redes.
- `data "aws_availability_zones"` seleciona as AZs disponíveis.
- Distribuição: pública na AZ 0, privada 1 na AZ 1, privada 2 na AZ 2 (ou
  reutiliza a AZ 0 se a região tiver apenas 2 AZs), garantindo ao menos 2
  AZs distintas.

## Bloco 4 — Tags obrigatórias (0,5 min) — Integrante 1

- Local `common_tags = { MVP = "MVP1" }` centraliza as tags comuns.
- Cada recurso aplica `merge(local.common_tags, { Name = "irede-mvp-1-<id>" })`.
- Todos os `Name` começam exatamente com `irede-mvp-1`.

## Bloco 5 — Funcionamento do roteamento público (1,5 min) — Integrante 2

- Internet Gateway anexado à VPC.
- Tabela de rotas pública com rota `0.0.0.0/0` -> IGW.
- Associação da tabela pública à sub-rede pública.
- `map_public_ip_on_launch = true` na sub-rede pública.

## Bloco 6 — Isolamento das sub-redes privadas (1 min) — Integrante 3

- As sub-redes privadas não são associadas a nenhuma tabela customizada.
- Usam a main route table da VPC, que tem apenas a rota local.
- Sem rota para a Internet, sem NAT Gateway, sem IPv4 público automático.

## Bloco 7 — Resultados dos comandos de validação (1 min) — Integrante 4

Apresentar o resultado real dos comandos executados:
- `terraform init`
- `terraform fmt -check`
- `terraform validate`
- `terraform plan` (apenas se houver acesso AWS autorizado)

> Não afirmar que um comando foi executado se isso não ocorreu. Se não
> houver credenciais AWS, informar que apenas as validações locais foram
> realizadas e nenhum recurso foi provisionado.

## Bloco 8 — Ajustes feitos pela equipe (0,5 min) — Integrante 4

- Relatar os ajustes reais registrados em `RELATORIO.md`.
- Se nenhum ajuste foi necessário, declarar que a implementação inicial
  atendeu aos requisitos sem correções.

## Bloco 9 — Segurança e prevenção de custos (0,5 min) — Integrante 1

- Sem credenciais no código; uso do ambiente/perfil AWS.
- Sem NAT Gateway, Elastic IP, EC2 ou recursos que gerem custos contínuos.
- `terraform destroy` ao final para remover tudo e evitar cobranças.

---

## Dicas para a apresentação

- Manter o tempo de cada bloco; ensaiar com cronômetro.
- Projetar o código ao vivo (VS Code) para mostrar os arquivos conforme fala.
- Se o `terraform plan` for demonstrado, executar antes e mostrar o resumo.
- Finalizar reforçando que nenhum recurso permanece provisionado após o
  `terraform destroy`.
