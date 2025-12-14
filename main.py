import argparse
import subprocess
import sys
import os
import json
from datetime import datetime

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SHARED_DIR = os.path.join(BASE_DIR, 'shared')
MAAS_DIR = os.path.join(BASE_DIR, 'maas')
TF_DIR = os.path.join(BASE_DIR, 'terraform')
ANSIBLE_DIR = os.path.join(BASE_DIR, 'ansible')


def log(msg, level="INFO"):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    colors = {"INFO": "\033[94m", "SUCCESS": "\033[92m", "ERROR": "\033[91m", "RESET": "\033[0m"}
    print(f"{colors.get(level, '')}[{timestamp}] [{level}] {msg}{colors['RESET']}")


def check_requirements():
    tools = ["terraform", "ansible-playbook", "python3"]
    for tool in tools:
        if subprocess.call(["which", tool], stdout=subprocess.DEVNULL) != 0:
            log(f"Ferramenta necessária não encontrada: {tool}", "ERROR")
            sys.exit(1)


def run_step_1_provision():
    log("ETAPA 1: Provisionando Hardware no MAAS...")
    try:
        cmd = [sys.executable, os.path.join(MAAS_DIR, "deploy_nodes.py")]
        subprocess.run(cmd, check=True)

        if not os.path.exists(os.path.join(SHARED_DIR, "terraform.tfvars")):
            raise FileNotFoundError("O script do MAAS não gerou o shared/terraform.tfvars")

        log("Hardware provisionado e variáveis geradas com sucesso.", "SUCCESS")
    except Exception as e:
        log(f"Falha no provisionamento: {e}", "ERROR")
        sys.exit(1)


def run_step_2_infra():
    log("ETAPA 2: Aplicando Infraestrutura Lógica (Terraform)...")
    tf_vars = os.path.join(SHARED_DIR, "terraform.tfvars")

    try:
        subprocess.run(["terraform", "-chdir=" + TF_DIR, "init"], check=True)
        cmd = ["terraform", "-chdir=" + TF_DIR, "apply", "-auto-approve", f"-var-file={tf_vars}"]
        subprocess.run(cmd, check=True)
        log("Infraestrutura Terraform aplicada.", "SUCCESS")
    except subprocess.CalledProcessError:
        log("Erro na execução do Terraform.", "ERROR")
        sys.exit(1)


def run_step_3_config():
    log("ETAPA 3: Configuração de Software (Ansible)...")
    inventory_script = os.path.join(ANSIBLE_DIR, "inventory_loader.py")

    try:
        cmd = ["ansible-playbook", "-i", inventory_script, os.path.join(ANSIBLE_DIR, "site.yml")]
        log("Ansible executado (Simulação).", "SUCCESS")
    except Exception as e:
        log(f"Erro no Ansible: {e}", "ERROR")


def main():
    parser = argparse.ArgumentParser(description="Ortzion Infrastructure CLI")
    subparsers = parser.add_subparsers(dest="command", help="Comandos disponíveis")

    subparsers.add_parser("check", help="Verifica dependências")
    subparsers.add_parser("deploy", help="Executa pipeline completa (MAAS -> TF -> Ansible)")
    subparsers.add_parser("destroy", help="Destrói tudo (CUIDADO)")

    args = parser.parse_args()

    if args.command == "check":
        check_requirements()
    elif args.command == "deploy":
        check_requirements()
        run_step_1_provision()
        run_step_2_infra()
        run_step_3_config()
    elif args.command == "destroy":
        log("Implementar destruição segura aqui!", "ERROR")
    else:
        parser.print_help()


if __name__ == "__main__":
    main()