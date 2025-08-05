terraform {
  backend "s3" {
    bucket = "projeto-devops"
    key    = "devops-project/terraform.tfstate"
    region = "sa-east-1"
  }
}