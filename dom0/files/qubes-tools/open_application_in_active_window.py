#!/usr/bin/python3

from qubes_utils import get_name_of_front_vm
from sys import argv
import os


def main():
    vm_name = get_name_of_front_vm()

    command = get_command_to_execute(vm_name)
    os.system(command)


def get_command_to_execute(vm_name):
    try:
        user = argv[3]
    except IndexError:
        user = 'user'

    if vm_name == "dom0" and not user == "user" and argv[1] == 'xterm':
        return f"xterm -e 'sudo su {user} -l'"
    elif vm_name == "dom0" and not user == "user" and not argv[1] == 'xterm':
        return f"sudo -H -u {user} bash -c '{argv[1]}'"
    elif vm_name == "dom0":
        return argv[1]


    command_to_execute = argv[2]

    return f"qvm-run -u {user} {vm_name} {command_to_execute}"


if __name__ == "__main__":
    main()
