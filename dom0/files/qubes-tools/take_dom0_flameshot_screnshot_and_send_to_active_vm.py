#!/usr/bin/python3


from qubes_utils import get_name_of_front_vm
from datetime import datetime

from pathlib import Path
import subprocess

def main():
    vm_name = get_name_of_front_vm()


    if vm_name == "dom0":
        vm_name = "vault"

    date = datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

    output_filename = f"{date}.png"
    screenshot_command = ["flameshot", "gui", "--raw"]

    with open(f"/tmp/{output_filename}", "w") as output_file:
        subprocess.run(screenshot_command, stdout=output_file)

    # Avoid exiting flameshot and moving an aborted screenshot
    file_size = Path(f"/tmp/{output_filename}").stat().st_size
    if file_size:
        move_screenshot_to_target_vm_command = ["qvm-move-to-vm", vm_name, f"/tmp/{output_filename}"]
        open_thunar_and_highlight_file_command = ["qvm-run", vm_name, f"thunar /home/user/QubesIncoming/dom0/{output_filename}"]

        subprocess.run(move_screenshot_to_target_vm_command)
        subprocess.run(open_thunar_and_highlight_file_command)


if __name__ == "__main__":
    main()
