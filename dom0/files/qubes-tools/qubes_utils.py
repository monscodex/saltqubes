#!/usr/bin/python3

import subprocess
import re

def get_all_vms_using_network_vm(net_vm):
    qvm_ls_command = subprocess.run(['qvm-ls', '--format=network', '--raw-data'], check=True, capture_output=True)

    # Output format: vmname|state|net-vm
    qvm_ls_output = qvm_ls_command.stdout.decode('utf-8')

    search_expression = '([-_a-zA-Z0-9]+)\|[a-zA-Z]+\|' + net_vm

    vms_using_netvm = re.findall(search_expression, qvm_ls_output)

    return vms_using_netvm


def get_name_of_front_vm():
    window_id = get_front_window_id()

    vm_name = get_vm_name_with_window_id(window_id)

    return vm_name



def get_name_of_templatevm_of_vm(vm_name):
    qubes_ls = subprocess.run(['qvm-ls', vm_name], check=True, capture_output=True)

    awk_parsing = subprocess.run(['awk', 'FNR == 2 {print $5}'], input=qubes_ls.stdout, capture_output=True)

    templatevm_name = awk_parsing.stdout.decode('utf-8').strip()

    return templatevm_name


def get_front_window_id():
    xprop_command = subprocess.run(['xprop', '-notype', '-root', '_NET_ACTIVE_WINDOW'], check=True, capture_output=True)

    xprop_output = xprop_command.stdout.decode('utf-8')

    print(xprop_output)
    window_id = re.search("^_NET_ACTIVE_WINDOW: window id # (0x[0-9a-f]{1,7})", xprop_output)
    print(window_id.group(1))

    return window_id.group(1)

def get_vm_name_with_window_id(window_id):
    # If there is no window opened in the desktop default to dom0
    if window_id == "0x0":
        return 'dom0'

    xprop_command = subprocess.run(['xprop', '-id', window_id, '-notype', '_QUBES_VMNAME'], check=True, capture_output=True)

    xprop_output = xprop_command.stdout.decode('utf-8')

    vm_name = re.search('^_QUBES_VMNAME = \"(.*)\"$', xprop_output)

    if vm_name:
        return vm_name.group(1)

    # Else, there isn't a match for the vm_name, it's because it's a dom0 window
    return 'dom0'
