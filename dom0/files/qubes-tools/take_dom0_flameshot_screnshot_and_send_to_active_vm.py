#!/usr/bin/python3

from qubes_utils import get_name_of_front_vm
import os
from datetime import datetime


def main():
    vm_name = get_name_of_front_vm()

    if vm_name == "dom0":
        vm_name = "vault"

    date = datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

    output_filename = f"/tmp/{date}.png"
    command = f"flameshot gui --raw > {output_filename} && qvm-move-to-vm {vm_name} {output_filename}"

    os.system(command)

if __name__ == "__main__":
    main()
