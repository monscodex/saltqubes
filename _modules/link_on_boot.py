import os

import hashlib

from pathlib import Path

def __virtual__():
    return 'link_on_boot'

from dataclasses import dataclass

# Do NOT Modify this path if you have EVER run this module before
# If you modify it at, it is at your own risk, and remember running the previously installed script on ALL Templates you have used it on.
CLEANUP_SCRIPT_LOCATION = Path('/opt/saltqubes/link_on_boot/cleanup_current_installation')


PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH = Path('/home/user/.local/state/saltqubes/link_on_boot/links_from_previous_boot_still_active')


"""
Requirements of each link_on_boot version:

    1. When installing link_on_boot, one must execute the script at {CLEANUP_SCRIPT_LOCATION} if it exists, then remove it and link {CLEANUP_SCRIPT_LOCATION} to the new installation's cleanup script location
    2. The links services of the current boot will wait wait to be executed until the file {PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH} is removed.
    3. When all the links of the current boot are done, the file {PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH} must be created.
"""

"""
    The current version of the software executes in the following order:
    1. unlinking (and removing the linking lock file)
    2. creating the unlinking service
    3. linking
    4. creating the linking lock file
"""

@dataclass
class FilePathAndContents:
    path: Path
    contents: str

    def replace_placeholder(self, placeholder: str, new_value: str) -> None:
        self.path = Path(str(self.path).replace(placeholder, new_value))
        self.contents = self.contents.replace(placeholder, new_value)

# Utility script because running bash directly in a systemd service file is kinda ugly

def _convert_full_posix_path_to_safe_file_name(path_str: str) -> str:
    """flsdlfadsfasdf"""
    return path_str.replace('/', '@').replace('.', '@@')


def _cleanup_old_module_installation_if_any(new_target: str):
    cleanup_str = str(CLEANUP_SCRIPT_LOCATION)

    # If there was no previous installation of link on boot
    if not __salt__['file.file_exists'](cleanup_str) and not __salt__['file.is_link'](cleanup_str):
        return

    target_link = __salt__['file.readlink'](cleanup_str)


    # If installing the same version!!
    if target_link == new_target:
        return

    res = __salt__['cmd.run_all'](cleanup_str)

    if res['retcode']:
        raise RuntimeError(f"Cleanup script failed: {res.get('stderr')}")

    if target_link:
        __salt__['file.remove'](target_link)

    __salt__['file.remove'](cleanup_str)
    

def _get_hash_from_hashables_tuple(hashables: tuple[FilePathAndContents, ...]) -> str:
    x = str(hashables).encode('utf-8')
    return hashlib.sha1(x).hexdigest()



def _pre():
    placeholder_for_hash = "XXXXXXXXXXXPlaceholderForHashXXXXXXXXXXX"



    move_preserving_times_bash_func = """
move_preserving_times() {
    local src="$1"
    local dst="$2"

    if [ "$src" = "$dst" ]; then
        return 0
    fi

    local atime mtime
    atime=$(stat -c '%x' "$src")
    mtime=$(stat -c '%y' "$src")


    if [ -e "$dst" ] || [ -L "$dst" ]; then
        rm -rf "$dst"
    fi

    mv "$src" "$dst"

    touch -a -d "$atime" "$dst"
    touch -m -d "$mtime" "$dst"
}
"""



    previous_boot_linked_files_path = Path(f"/home/user/.local/state/saltqubes/link_on_boot/previous_boot_linked_files_{placeholder_for_hash}")

    unlink_next_boot_executable_path = Path(f"/home/user/.local/bin/saltqubes_unlink_next_boot_{placeholder_for_hash}")
    unlink_next_boot_service_path = Path(f"/home/user/.config/systemd/user/saltqubes-unlink_next_boot-on-boot_{placeholder_for_hash}.service")
    unlink_next_boot_service_creator_unit_path = Path(f"/etc/systemd/system/saltqubes_unlink_next_boot_service_creator_{placeholder_for_hash}.service")

    unlink_next_boot_service_executable = FilePathAndContents(
        path=unlink_next_boot_executable_path,
        contents=f"""#!/usr/bin/env bash
{move_preserving_times_bash_func}

mkdir -p "{previous_boot_linked_files_path.parent}"

PREVIOUS_BOOT_STATE="{previous_boot_linked_files_path}.old"

CANARY_UNLINKED_BEFORE_AUTOREMOVAL_PATH="/tmp/saltqubes_link_on_boot_canary_successful_autoremoval_{placeholder_for_hash}"

[ -f "$CANARY_UNLINKED_BEFORE_AUTOREMOVAL_PATH" ] && rm -f "$CANARY_UNLINKED_BEFORE_AUTOREMOVAL_PATH"

[ -f "{previous_boot_linked_files_path}" ] && mv -f "{previous_boot_linked_files_path}" "$PREVIOUS_BOOT_STATE"

touch "{previous_boot_linked_files_path}"
 
if [ -f "$PREVIOUS_BOOT_STATE" ]; then
    while IFS= read -r LINKED_PATH || [ -n "$LINKED_PATH" ]; do
        if [ -L "$LINKED_PATH" ]; then
            unlink "$LINKED_PATH"
        fi

        BACKUP_PATH="${{LINKED_PATH}}_{placeholder_for_hash}"
        if [ -e "$BACKUP_PATH" ]; then
            move_preserving_times "$BACKUP_PATH" "$LINKED_PATH"
        fi
    done < "$PREVIOUS_BOOT_STATE"

    rm -f "$PREVIOUS_BOOT_STATE"
fi

# We do this to save i/o and disk/usage. There can only be 1 version of the creator service installed (because we first clean up, then install)
if [ ! -f "{unlink_next_boot_service_creator_unit_path}" ]; then
    export XDG_RUNTIME_DIR="${{XDG_RUNTIME_DIR:-/run/user/$(id -u)}}"
    systemctl --user disable "{unlink_next_boot_service_path.name}"
    rm -f "{unlink_next_boot_service_path}"
    systemctl --user daemon-reload

    # Nobody is going to need this now because it was tied to a specific version of the module
    rm -f "{previous_boot_linked_files_path}"

    rm -f "{unlink_next_boot_executable_path}"
    touch "$CANARY_UNLINKED_BEFORE_AUTOREMOVAL_PATH"
fi

# Delete Canary
rm -f "{PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH}"
"""
    )

    unlink_next_boot_service_unit = FilePathAndContents(
        path=unlink_next_boot_service_path,
        contents=f"""[Unit]
Description=Unlinks previously all linked files on last boot.

[Service]
Type=simple
ExecStart={unlink_next_boot_service_executable.path}
Environment=PATH=/usr/bin:/bin:%h/.local/bin

[Install]
WantedBy=default.target
"""
    )


    unlink_next_boot_service_creator_executable = FilePathAndContents(
        path=Path(f"/opt/saltqubes/link_on_boot/create_unlink_next_boot_service_{placeholder_for_hash}"),
        contents=f"""#!/usr/bin/env bash
set -euo pipefail

# Wait until canary is deleted
while [ -f "{PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH}" ]; do
    sleep 0.1
done

export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# do not create unlinking service again
if [ -f "{unlink_next_boot_service_unit.path}" ] && systemctl --user --machine=user@.host is-enabled "{unlink_next_boot_service_unit.path.name}" &>/dev/null; then
    exit 0
fi

mkdir -p "{unlink_next_boot_service_executable.path.parent}"
mkdir -p "{previous_boot_linked_files_path.parent}"
mkdir -p "{unlink_next_boot_service_unit.path.parent}"

cat << 'EOF' > "{unlink_next_boot_service_unit.path}"
{unlink_next_boot_service_unit.contents}
EOF

cat << 'EOF' > "{unlink_next_boot_service_executable.path}"
{unlink_next_boot_service_executable.contents}
EOF

chmod +x "{unlink_next_boot_service_executable.path}"

# Connect to the user systemd bus
systemctl --user --machine=user@.host daemon-reload

# Not started now because:
# 1. if there was a previous version installed, old links are already unlinked
# 2. if it is the previous version, nothing is installed so nothing to unlink
systemctl --user --machine=user@.host enable "{unlink_next_boot_service_unit.path.name}"
"""
    )

    unlink_next_boot_service_creator_unit = FilePathAndContents(
        path=unlink_next_boot_service_creator_unit_path,
        contents=f"""[Unit]
Description=Creates the Corresponding Systemd User service that Unlinks on Boot, if it is not already created and enabled
After=local-fs.target home.mount user@1000.service
Wants=user@1000.service

[Service]
Type=oneshot
ExecStart={unlink_next_boot_service_creator_executable.path}
RemainAfterExit=yes
User=user
Group=user

[Install]
WantedBy=multi-user.target"""
    )

    canary_creator_unit = FilePathAndContents(
        path=Path(f"/etc/systemd/system/saltqubes_canary_creator_{placeholder_for_hash}.service"),
        contents=f"""[Unit]
Description=Creates canary file indicating links from current boot are still active
After=local-fs.target home.mount {unlink_next_boot_service_creator_unit.path.name}

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'mkdir -p "{PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH.parent}" && touch "{PREVIOUS_BOOT_LINKS_ACTIVE_CANARY_PATH}"'
RemainAfterExit=yes
User=user
Group=user

[Install]
WantedBy=multi-user.target"""
    )


    link_worker_executable = FilePathAndContents(
        path=Path(f"/opt/saltqubes/link_on_boot/do_link_{placeholder_for_hash}"),
        contents=f"""#!/usr/bin/bash
set -euo pipefail

{move_preserving_times_bash_func}

DEST_PATH="$1"
SRC_PATH="$2"

append_linked_file_to_list () {{
    mkdir -p "{previous_boot_linked_files_path.parent}"
    (
        flock 200
        echo "$DEST_PATH" >> "{previous_boot_linked_files_path}"
    ) 200>>"{previous_boot_linked_files_path}"
}}

if [ -L "$DEST_PATH" ]; then
    if [ "$(readlink -f "$DEST_PATH")" -ef "$SRC_PATH" ]; then
        append_linked_file_to_list;
        exit 0;
    else
        unlink "$DEST_PATH"
    fi
elif [ -d "$DEST_PATH" ] || [ -f "$DEST_PATH" ]; then
    move_preserving_times "$DEST_PATH" "$(echo "$DEST_PATH")_{placeholder_for_hash}"
fi


mkdir -p "$(dirname "$DEST_PATH")"
ln -sf "$SRC_PATH" "$DEST_PATH"

append_linked_file_to_list;
"""
    )



    cleanup_script_current_link_on_boot_installation = FilePathAndContents(
        path=f"{CLEANUP_SCRIPT_LOCATION}_{placeholder_for_hash}",
        contents=f"""#!/usr/bin/env bash
systemctl disable "{unlink_next_boot_service_creator_unit.path.name}"
rm -f "{unlink_next_boot_service_creator_unit.path}"
rm -f "{unlink_next_boot_service_creator_executable.path}"
rm -f "{link_worker_executable.path}"
rm -f "{canary_creator_unit.path}"
rm -f /etc/systemd/system/saltqubes_link_*_{placeholder_for_hash}.service
systemctl daemon-reload

# running service after deleting, this simulates switching templates that will autodestroy it
USER_UID=$(id -u user)
runuser -u user -- env XDG_RUNTIME_DIR="/run/user/$USER_UID" systemctl --user start {unlink_next_boot_service_unit.path.name}
"""
    )

    tuple_files_and_contents = (
        unlink_next_boot_service_unit,
        unlink_next_boot_service_executable,
        unlink_next_boot_service_creator_unit,
        unlink_next_boot_service_creator_executable,
        canary_creator_unit,
        link_worker_executable,
        cleanup_script_current_link_on_boot_installation
    )

    version_hash = _get_hash_from_hashables_tuple(tuple_files_and_contents)

    for file_and_contents in tuple_files_and_contents:
        file_and_contents.replace_placeholder(placeholder_for_hash, version_hash)

    __context__['link_on_boot_version_hash'] = version_hash
    __context__['link_worker_executable_path'] = str(link_worker_executable.path)

    from copy import copy
    __context__['canary_creator_unit_name'] = copy(canary_creator_unit.path.name)

    __salt__['cmd.run']('loginctl enable-linger user')

    ret = __salt__['state.single'](
        fun='file.managed',
        name=str(cleanup_script_current_link_on_boot_installation.path),
        mode='0755',
        makedirs=True,
        contents=cleanup_script_current_link_on_boot_installation.contents
    )


    _cleanup_old_module_installation_if_any(new_target=str(cleanup_script_current_link_on_boot_installation.path))

    __salt__['state.single'](
        fun='file.symlink',
        name=str(CLEANUP_SCRIPT_LOCATION),
        target=str(cleanup_script_current_link_on_boot_installation.path),
        force=True
    )

    ret = __salt__['state.single'](
        fun='file.managed',
        name=str(unlink_next_boot_service_creator_executable.path),
        mode='0755',
        makedirs=True,
        contents=unlink_next_boot_service_creator_executable.contents
    )

    ret = __salt__['state.single'](
        fun='file.managed',
        name=str(unlink_next_boot_service_creator_unit.path),
        user='root',
        group='root',
        mode='0644',
        contents=unlink_next_boot_service_creator_unit.contents
    )

    ret = __salt__['state.single'](
        fun='file.managed',
        name=str(canary_creator_unit.path),
        user='root',
        group='root',
        mode='0644',
        contents=canary_creator_unit.contents
    )

    ret = __salt__['state.single'](
        fun='file.managed',
        name=str(link_worker_executable.path),
        mode='0755',
        makedirs=True,
        contents=link_worker_executable.contents
    )

    ret = __salt__['state.single'](fun='service.systemctl_reload', name=None)

    ret = __salt__['state.single'](
        fun='service.enabled',
        name=canary_creator_unit.path.name,
    )

    ret = __salt__['state.single'](
        fun='service.enabled',
        name=unlink_next_boot_service_creator_unit.path.name,
    )

    # IMPORTANT: if we install link_on_boot, then change the module (without rebooting the Template at any point), we will need to have the unlink service available in order to clean it
    ret = __salt__['state.single'](
        fun='service.running',
        name=unlink_next_boot_service_creator_unit.path.name,
        enable=True,
    )

    __context__['link_on_boot_pre_func_ran'] = True


def link(link_path, source_path):
    """flsdlfadsfasdf"""

    # If the _pre has not run for the current salt execution
    if not __context__.get('link_on_boot_pre_func_ran', False):
        _pre()

    version_hash = __context__['link_on_boot_version_hash']
    canary_creator_unit_name = __context__['canary_creator_unit_name']
    worker_script = __context__['link_worker_executable_path']

    safe_name = _convert_full_posix_path_to_safe_file_name(link_path)
    link_unit = FilePathAndContents(
        path=Path(f"/etc/systemd/system/saltqubes_link_{safe_name}_{version_hash}.service"),
        contents = f"""[Unit]
Description=Link on boot: {link_path} -> {source_path}
After=local-fs.target home.mount saltqubes_unlink_next_boot_service_creator_{version_hash}.service
Before={canary_creator_unit_name}
Wants={canary_creator_unit_name}

[Service]
Type=oneshot
ExecStart={worker_script} "{link_path}" "{source_path}"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
"""
    )

    ret = __salt__['state.single'](
        fun='file.managed',
        name=str(link_unit.path),
        user='root',
        group='root',
        mode='0644',
        contents=link_unit.contents
    )

    ret = __salt__['state.single'](fun='service.systemctl_reload', name=None)

    ret = __salt__['state.single'](
        fun='service.enabled',
        name=link_unit.path.name,
    )

    return ret
