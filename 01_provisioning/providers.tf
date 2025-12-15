terraform {
  # Trava a versão do Terraform para evitar quebras futuras
  required_version = ">= 1.0.0"

  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "~> 2.0" # Usa a versão 2.x estável
    }
  }
}

# Configuração do Provider
provider "maas" {
  api_version = "2.0"
  # Note que não colocamos a chave aqui. Referenciamos a variável.
  api_url     = var.maas_api_url
  api_key     = var.maas_api_key
}