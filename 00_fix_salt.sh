#!/usr/bin/bash

ln -s /srv/salt/qubes/user-dirs.top /srv/salt/_tops/base/user-dirs.top

qubesctl saltutil.clear_cache
qubesctl saltutil.sync_all refresh=True
