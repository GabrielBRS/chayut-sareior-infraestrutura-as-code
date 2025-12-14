import json

allocated_ips = ["192.168.1.10", "192.168.1.11"]

tfvars_content = f'cluster_nodes_ips = {json.dumps(allocated_ips)}\n'

with open("shared/terraform.tfvars", "w") as f:
    f.write(tfvars_content)

print(f"Gerado shared/terraform.tfvars com {len(allocated_ips)} nós.")