variable "cluster_nodes_ips" {
  type        = list(string)
  description = "IPs provisionados pelo script do MAAS"
}

resource "some_dns_record" "nodes" {
  count = length(var.cluster_nodes_ips)
  ip    = var.cluster_nodes_ips[count.index]
  # ...
}