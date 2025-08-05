# Pipeline Jenkins - Terraform AWS Python API

## 📋 Visão Geral da Arquitetura

- **Jenkins**: Região sa east 1 (Orquestração)
- **Aplicação Python**: Região sa east 1 (Infraestrutura principal)
- **Domínio**: `dominio.org` com subdomínio `jenkins.dominio.org`
- **Banco de Dados**: RDS MySQL em subnet privada
- **Load Balancer**: ALB com certificado SSL/TLS

## 🚀 Fase 2: Configuração do Pipeline Jenkins para Infraestrutura da Aplicação Python

Nesta fase, você usará o Jenkins para provisionar a infraestrutura da aplicação Python em uma região AWS diferente (sa east 1) da região do Jenkins (sa east 1).

### 1. Instalar Plugin AWS Pipeline Steps no Jenkins

1. No Jenkins, navegue para:
   ```
   Manage Jenkins > Plugins > Available plugins
   ```
2. Procure por `AWS Steps` e instale o plugin

### 2. Adicionar Credenciais AWS no Jenkins

1. Vá para:
   ```
   Manage Jenkins > Credentials > Global credentials > Add Credentials
   ```
2. Configure as credenciais:
   - **Tipo**: `AWS Credentials`
   - **ID**: `aws-creds-devops`
   - **Access Key ID**: Sua chave de acesso AWS
   - **Secret Access Key**: Sua chave secreta AWS

### 3. Criar um Novo Pipeline Jenkins

#### Configuração Inicial
1. No painel do Jenkins, clique em `New Item`
2. Digite um nome: `devops-project`
3. Selecione `Pipeline` e clique em `OK`

#### Configuração do Pipeline
Na página de configuração:

1. **Pipeline Section**: Selecione `Pipeline script from SCM`
2. **SCM**: Escolha `Git`
3. **Repository URL**: 
   ```
   https://github.com/brunomicael/terraform-projeto-api.git
   ```
4. **Credentials**: 
   - Repositórios públicos: deixe em branco
   - Repositórios privados: selecione as credenciais AWS criadas
5. **Branch Specifier**: `main`
6. **Script Path**: `Jenkinsfile`

7. Clique em `Apply` → `Save`

### 4. Executar o Pipeline Jenkins

O `Jenkinsfile` contém lógica para executar comandos Terraform com parâmetros configuráveis:

#### 🔄 Primeira Execução (Init)
```bash
# Clique em "Build Now"
# Por padrão, executará apenas: terraform init
```

#### 📋 Segunda Execução (Plan)
1. Clique em `Build with Parameters`
2. Marque: `☑️ Run Terraform Plan`
3. Clique em `Build`

> **✅ Verificação**: Console deve mostrar que **28 recursos** serão criados

#### 🚀 Terceira Execução (Apply)
1. Clique em `Build with Parameters`
2. Marque:
   - `☑️ Run Terraform Plan`
   - `☑️ Run Terraform Apply`
3. Clique em `Build`

#### 📦 Recursos Provisionados

Esta execução criará toda a infraestrutura da aplicação:

| Componente | Módulo | Descrição |
|------------|--------|-----------|
| **Rede** | `rede` | VPC, subnets, IGW, route tables |
| **EC2** | `ec2` | Instância para aplicação Python (porta 5000) |
| **RDS** | `rds` | MySQL em subnet privada |
| **Load Balancer** | `load-balancer` | ALB com listeners 80/443 |
| **DNS** | `zona-hospedagem` | Route 53 para `dominio.org` |
| **Certificado** | `certificate-manager` | SSL/TLS via ACM para `dominio.org` |

> **📍 Monitoramento**: Acompanhe o console Jenkins e AWS Console (Região sa east 1)

## ✅ Fase 3: Verificação da Aplicação Python REST API

### 1. Acessar a Aplicação

Abra um navegador (modo incógnito recomendado):
```
http://dominio.org
```

Você deverá ver a página inicial da aplicação Flask.

### 2. Interagir com a API (CRUD)

#### Criar Tabela no Banco
```
GET http://dominio.org/create_table
```

#### Inserir Registros
```
GET http://dominio.org/insert_record
```

### 3. Conectar ao Banco de Dados MySQL (RDS)

#### Usando MySQL Workbench

**Configuração da Conexão**:
- **Método**: `Standard TCP/IP over SSH`

**SSH Configuration**:
- **SSH Hostname**: IP público da instância EC2
- **SSH Username**: `ubuntu`
- **SSH Key File**: Caminho para chave privada SSH

**MySQL Configuration**:
- **MySQL Hostname**: Endpoint RDS (obtido no AWS Console)
- **MySQL Port**: `3306`
- **MySQL Username**: `dbuser`
- **MySQL Password**: `dbpassword` (conforme configuração Terraform)

#### Verificação dos Dados
1. Teste a conexão
2. Conecte-se ao banco
3. Navegue pelos esquemas: `Dev project DB`
4. Verifique a tabela: `example_table`
5. Confirme os registros inseridos

## 🗑️ Fase 4: Destruição do Ambiente

### 1. Limpar Recursos da Aplicação

#### Via Pipeline Jenkins
1. Vá para o pipeline `devops-project-1`
2. Clique em `Build with Parameters`
3. Marque: `☑️ Run Terraform Destroy`
4. Clique em `Build`

> **⚠️ Atenção**: Isso destruirá **toda** a infraestrutura da aplicação Python (EC2, RDS, ALB, Route 53, etc.)

### 2. Limpar Recursos do Jenkins

#### Via Terraform Local
Para destruir a infraestrutura do Jenkins:

```bash
# No diretório local do repositório
cd terraform-projeto-api

# Remover comentários dos módulos Jenkins
# Comentar módulos da aplicação no main.tf

terraform destroy
```

**Alternativa**: Se existir um subdiretório `terraform-jenkins` com seu próprio `main.tf`:
```bash
cd terraform-jenkins
terraform destroy
```

## 📚 Recursos e Referências

### Estrutura do Projeto
```
terraform-projeto-api/
├── main.tf                    # Configuração principal
├── terraform.tfvars          # Variáveis do projeto
├── Jenkinsfile               # Pipeline definition
├── jenkins-runner-script/
│   └── installation-script.sh
└── template/
    └── ec2-python-application.sh
```

### Módulos Utilizados
- `rede` - Configuração de rede (VPC, subnets)
- `ec2` - Instâncias EC2
- `rds` - Banco de dados MySQL
- `load-balancer` - Application Load Balancer
- `zona-hospedagem` - Route 53 DNS
- `certificate-manager` - Certificados SSL/TLS
- `grupo-de-seguranca` - Security Groups

### Comandos Terraform Principais
```bash
terraform init      # Inicializar
terraform plan      # Planejar mudanças
terraform apply     # Aplicar mudanças
terraform destroy   # Destruir recursos
```

## 💡 Melhores Práticas

- **Monitoramento**: Sempre acompanhe logs do Jenkins e AWS CloudWatch
- **Segurança**: Use chaves SSH únicas para cada ambiente
- **Versionamento**: Mantenha branches separadas para desenvolvimento/produção
- **Backup**: Configure backups automáticos do RDS
- **Custos**: Destrua recursos de teste após uso

