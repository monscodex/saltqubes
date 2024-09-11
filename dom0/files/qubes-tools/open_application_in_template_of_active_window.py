#!/usr/bin/python3

from qubes_utils import get_name_of_front_vm, get_name_of_templatevm_of_vm
from sys import argv
import os


def main():
    vm_name = get_name_of_front_vm()

    if vm_name == "dom0":
        return

    templatevm_name = get_name_of_templatevm_of_vm(vm_name)

    command = get_command_to_execute(templatevm_name)
    
    os.system(command)


def get_command_to_execute(templatevm_name):
    command_to_execute = argv[1]

    return f"qvm-run {templatevm_name} {command_to_execute}"


if __name__ == "__main__":
    main()
