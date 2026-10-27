# providers.tf
# Configura o provider AWS utilizando a região definida por variável.
#
# As credenciais NÃO são declaradas no código. O provider as obtém
# automaticamente do ambiente (AWS CLI, variáveis de ambiente, perfil
# configurado em ~/.aws/credentials ou role assumida). Nunca insira
# access_key/secret_key em arquivos .tf.

provider "aws" {
  region = var.aws_region
}
