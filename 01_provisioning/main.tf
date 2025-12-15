# --- CONFIGURAÇÃO COMUM (CLOUD-INIT) ---
# Definimos isso aqui uma vez para não repetir código
locals {
  cloud_config = <<EOF
#cloud-config
locale: pt_BR.UTF-8
timezone: America/Sao_Paulo
keyboard:
  layout: br
  model: abnt2

# Criação de usuários
users:
  - name: gabriel
    groups: [sudo, docker]
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAA... (COLOQUE_SUA_CHAVE_PUBLICA_REAL_AQUI)

# Pacotes essenciais para diagnóstico
packages:
  - curl
  - wget
  - git
  - htop
  - net-tools

# Comandos de Bootstrap
runcmd:
  - apt-get update
  - touch /root/instalado_via_maas.txt
  - echo "Servidor provisionado via Terraform em $(date)" >> /etc/motd
EOF
}

# --- MASTER NODES (Control Plane) ---
resource "maas_instance" "k8s_master" {
  count = 1

  allocate_params {
    min_cpu_count = 4
    min_memory    = 16384 # 16GB
    tags          = ["dell-server", "ssd"]
  }

  deploy_params {
    distro_series = "jammy" # Ubuntu 22.04
  }

  # AQUI ESTÁ A CORREÇÃO: Injetamos o cloud-init neste nó
  user_data = local.cloud_config
}

# --- WORKER NODES ---
resource "maas_instance" "k8s_worker" {
  count = 2

  allocate_params {
    min_cpu_count = 8
    min_memory    = 32768 # 32GB
  }

  deploy_params {
    distro_series = "jammy"
  }

  # Injetamos o mesmo cloud-init nos workers
  user_data = local.cloud_config
}

# --- GERAÇÃO DO INVENTÁRIO ANSIBLE ---
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    masters = maas_instance.k8s_master.*.ip_addresses
    workers = maas_instance.k8s_worker.*.ip_addresses
  })
  filename = "../02_configuration/inventory/hosts.ini"
}