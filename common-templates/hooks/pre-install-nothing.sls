include:
# Xterm will have nice config but no font installed by default
# Set custom dpi for templates not running with gnome
    - common-templates.command-line.terminal.xterm
# Locale fix is compulsory
    - {{ slsdotpath }}.locale-fix
# Set custom dpi for templates with gnome settings
    - {{ slsdotpath }}.gnome-set-dpi
