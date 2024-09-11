#!/usr/bin/bash

echo "WARNING!! Only back up config files from UNEDITABLE CONFIGS (xfce).\nElse edit from ./dotfiles and run *qubesctl state.sls dom0*"

# Copy configurations and scripts
rm -rf /srv/user_salt/dotfiles/xfce4/xconf/
cp -rf /home/adminabs/.config/xfce4/xfconf /srv/user_salt/dotfiles/xfce4/xconf
