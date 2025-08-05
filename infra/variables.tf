variable "bucket_nome" {
  type        = string
  description = "nome"
}

variable "nome" {
  type        = string
  description = "Tag nome"
}

variable "environment" {
  type        = string
  description = "Environment nome"
}

variable "vpc_cidr" {
  type        = string
  description = "publico Subnet CIDR valores"
}

variable "vpc_nome" {
  type        = string
  description = "DevOps Project 1 VPC 1"
}

variable "cidr_publico_subnet" {
  type        = list(string)
  description = "subnet publica CIDR valores"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "subnet privada CIDR valores"
}

variable "sa_availability_zone" {
  type        = list(string)
  description = "AZ"
}

variable "chave" {
  type        = string
  description = "chave do projeto"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI id do projeto"
}

variable "ec2_user_data_install_apache" {
  type = string
  description = "instalação apache2"
}

variable "nome_dominio" {
  type = string
  description = "nome do dominio"
}