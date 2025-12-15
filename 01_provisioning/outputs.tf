output "master_ips" {
  description = "Lista de IPs alocados para os Masters"
  value       = maas_instance.k8s_master.*.ip_addresses
}

output "worker_ips" {
  description = "Lista de IPs alocados para os Workers"
  value       = maas_instance.k8s_worker.*.ip_addresses
}

output "ansible_inventory_path" {
  description = "Local onde o arquivo de inventário foi gerado"
  value       = abspath("../02_configuration/inventory/hosts.ini")
}