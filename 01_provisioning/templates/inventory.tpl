[masters]
%{ for ip in masters ~}
${ip[0]} ansible_user=ubuntu
%{ endfor ~}

[workers]
%{ for ip in workers ~}
${ip[0]} ansible_user=ubuntu
%{ endfor ~}

[k8s_cluster:children]
masters
workers