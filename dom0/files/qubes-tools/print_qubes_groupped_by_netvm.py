#!/usr/bin/python3

from sys import argv
import os

from qubes_utils import get_all_vms_using_network_vm

def main():
    net_vms = argv[1:]

    for net_vm in net_vms:
        vms_using_current_netvm = get_all_vms_using_network_vm(net_vm)

        print(f"\n\n###### Network VMs for {net_vm.upper()} ######")

        indenter = '\t- '
        separator = f"\n{indenter}"

        print(f"{indenter}{separator.join(vms_using_current_netvm)}")

if __name__ == "__main__":
    main()
