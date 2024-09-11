from sys import argv
import os

from qubes_utils import get_all_vms_using_network_vm

def main():
    old_netvm, new_netvm = argv[1], argv[2]
    vms = get_all_vms_using_network_vm(old_netvm)

    for vm in vms:
        print(f"Changing {vm}'s netmv to {new_netvm}")
        os.system(f'qvm-prefs {vm} netvm {new_netvm}')


if __name__ == "__main__":
    main()
