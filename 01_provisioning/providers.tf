terraform {
  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "~> 2.0" # Use a versão estável mais recente
    }
  }
}

provider "maas" {
  api_version = "2.0"
  api_key     = var.maas_api_key
  api_url     = var.maas_api_url # Ex: http://192.168.1.50:5240/MAAS
}