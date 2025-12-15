# --- Credenciais e Acesso (Sensíveis) ---
variable "maas_api_url" {
  description = "URL do servidor MAAS (ex: http://192.168.1.50:5240/MAAS)"
  type        = string
}

variable "maas_api_key" {
  description = "API Key gerada no painel do MAAS"
  type        = string
  sensitive   = true # Isso impede que a chave apareça nos logs do Terraform
}

variable "ssh_public_key" {
  description = "Sua chave pública SSH para acesso aos servidores"
  type        = string
}

# --- Dimensionamento do Cluster ---
variable "master_count" {
  description = "Quantidade de nós Master (Control Plane)"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Quantidade de nós Worker"
  type        = number
  default     = 2
}

# --- Configuração de Hardware (Flavor) ---
variable "master_ram_mb" {
  description = "Memória RAM mínima para os Masters"
  type        = number
  default     = 16384 # 16GB
}

variable "worker_ram_mb" {
  description = "Memória RAM mínima para os Workers"
  type        = number
  default     = 32768 # 32GB
}

variable "ubuntu_distro" {
  description = "Versão do Ubuntu a ser instalada (focal, jammy, noble)"
  type        = string
  default     = "jammy" # 22.04 LTS
}