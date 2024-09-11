from ranger.ext.img_display import ImageDisplayer, register_image_displayer, move_cur
from ranger.core.shared import FileManagerAware
import sys
import struct
import fcntl
import termios
import imghdr

from subprocess import check_output

class ITerm2ImageDisplayerHelper(ImageDisplayer, FileManagerAware):
    @staticmethod
    def _get_image_dimensions(path):
        """Determine image size using imghdr"""
        file_handle = open(path, 'rb')
        file_header = file_handle.read(24)
        image_type = imghdr.what(path)
        if len(file_header) != 24:
            file_handle.close()
            return 0, 0
        if image_type == 'png':
            check = struct.unpack('>i', file_header[4:8])[0]
            if check != 0x0d0a1a0a:
                file_handle.close()
                return 0, 0
            width, height = struct.unpack('>ii', file_header[16:24])
        elif image_type == 'gif':
            width, height = struct.unpack('<HH', file_header[6:10])
        elif image_type == 'jpeg':
            unreadable = OSError
            try:
                file_handle.seek(0)
                size = 2
                ftype = 0
                while not 0xc0 <= ftype <= 0xcf or ftype in (0xc4, 0xc8, 0xcc):
                    file_handle.seek(size, 1)
                    byte = file_handle.read(1)
                    while ord(byte) == 0xff:
                        byte = file_handle.read(1)
                    ftype = ord(byte)
                    size = struct.unpack('>H', file_handle.read(2))[0] - 2
                file_handle.seek(1, 1)
                height, width = struct.unpack('>HH', file_handle.read(4))
            except unreadable:
                height, width = 0, 0
        else:
            file_handle.close()
            return 0, 0
        file_handle.close()
        return width, height

    @staticmethod
    def _fit_width(width, height, max_width, max_height):
        if height > max_height:
            if width > max_width:
                width_scale = max_width / width
                height_scale = max_height / height
                min_scale = min(width_scale, height_scale)
                max_scale = max(width_scale, height_scale)
                if width * max_scale <= max_width and height * max_scale <= max_height:
                    return width * max_scale
                return width * min_scale

            scale = max_height / height
            return width * scale
        elif width > max_width:
            scale = max_width / width
            return width * scale

        return width

@register_image_displayer("sixel")
class SixelImageDisplayer(ImageDisplayer, FileManagerAware):
    def draw(self, path, start_x, start_y, max_cols, max_rows):
        rows, cols, xpixels, ypixels = self._get_terminal_dimensions()

        col_width = (xpixels // cols)
        row_height = (ypixels // rows)
        max_width = col_width * max_cols
        max_height = row_height * max_rows

        image_width, image_height = ITerm2ImageDisplayerHelper._get_image_dimensions(path)

        fit_image_width = int(ITerm2ImageDisplayerHelper._fit_width(
            image_width, image_height, max_width, max_height))
        fit_image_height = image_height * fit_image_width // image_width

        geometry = "{}x{}".format(fit_image_width, fit_image_height)
        args = ['magick', path + "[0]",
                '-geometry', geometry,
                "sixel:-"]
        sixel = check_output(args)

        move_cur(start_y, start_x)
        sys.stdout.buffer.write(sixel)
        sys.stdout.flush()

    def _get_terminal_dimensions(self):
        farg = struct.pack("HHHH", 0, 0, 0, 0)
        fd_stdout = sys.stdout.fileno()
        fretint = fcntl.ioctl(fd_stdout, termios.TIOCGWINSZ, farg)
        return struct.unpack("HHHH", fretint)

    def clear(self, start_x, start_y, width, height):
        self.fm.ui.win.redrawwin()
        self.fm.ui.win.refresh()
