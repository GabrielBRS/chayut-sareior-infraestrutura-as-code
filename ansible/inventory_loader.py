import os
import json
import sys

SHARED_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), '../shared/machines.json'))


def get_inventory():
    if not os.path.exists(SHARED_FILE):
        return {"_meta": {"hostvars": {}}}

    with open(SHARED_FILE, 'r') as f:
        data = json.load(f)

    inventory = {
        "bare_metal": {
            "hosts": data.get("ips", []),
            "vars": {
                "ansible_user": "ubuntu",
                "ansible_ssh_private_key_file": "~/.ssh/id_rsa"
            }
        },
        "_meta": {
            "hostvars": {}
        }
    }
    return inventory


if __name__ == "__main__":
    print(json.dumps(get_inventory()))