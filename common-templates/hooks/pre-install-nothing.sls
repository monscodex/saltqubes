include:
# Xterm will have nice config but no font installed by default
# Set custom dpi for templates not running with gnome
    - common-templates.command-line.terminal.xterm
# Set custom dpi for templates with gnome settings
    - {{ slsdotpath }}.gnome-set-dpi
# Locale fix is compulsory
    - {{ slsdotpath }}.locale-fix
