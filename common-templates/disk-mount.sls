install_disk_mounting_programs:
  pkg.installed:
    - pkgs:
      # File systems
      - exfatprogs
      - e2fsprogs
      - btrfs-progs
      - davfs2 # webdav
      - gnome-disk-utility
      - fuse
    - skip_suggestions: True
    - install_recommends: False
    - order: 1

add_fuse_kernel_module:
  kmod.present:
    - name: fuse

add_users_to_fuse_group:
  group.present:
    - name: fuse
    - addusers:
      - user
      - root
