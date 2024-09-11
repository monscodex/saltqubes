import os
import ranger.api
from ranger.core.linemode import LinemodeBase
from subprocess import check_output, PIPE







from plugins.ranger_devicons.devicons import devicon
from plugins.ranger_udisk_menu.mounter import mount

from plugins.ranger_fd_fzf_search import fzf_select, fd_search, fd_next, fd_prev

from plugins.ranger_sixel_image_preview import SixelImageDisplayer


SEPARATOR = os.getenv('RANGER_DEVICONS_SEPARATOR', ' ')

@ranger.api.register_linemode
class DevIconsLinemode(LinemodeBase):
  name = "devicons"

  uses_metadata = False

  def filetitle(self, file, metadata):
    return devicon(file) + SEPARATOR + file.relative_path


