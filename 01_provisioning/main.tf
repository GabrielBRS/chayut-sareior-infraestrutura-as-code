# --- MASTER NODES (Control Plane) ---
resource "maas_instance" "k8s_master" {
  count = 1
  # O Terraform pede ao MAAS para alocar uma máquina física
  allocate_params {
    min_cpu_count = 4
    min_memory    = 16384 # 16GB
    tags          = ["dell-server", "ssd"] # Tags definidas no MAAS
  }

  # O MAAS instala o OS via PXE
  deploy_params {
    distro_series = "jammy" # Ubuntu 22.04
  }
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
}

# --- GERAÇÃO DO INVENTÁRIO ANSIBLE ---
# Isso conecta o Terraform ao Ansible automaticamente
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    masters = maas_instance.k8s_master.*.ip_addresses
    workers = maas_instance.k8s_worker.*.ip_addresses
  })
  filename = "../02_configuration/inventory/hosts.ini"
}