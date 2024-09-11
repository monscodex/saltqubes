# HELP... CANNOT SET SALT GRAINS WITH grains.present
# ISSUE REPORTED IN https://forum.qubes-os.org/t/salt-grains-not-visible-to-target-vms/19151

{% set default_app='qvm-open-in-dvm.desktop' %}
{% set standard_repo_path='/usr/share/applications/' %}
{% set flatpak_repo_path='/var/lib/flatpak/exports/share/applications/' %}

{% set preferred_applications = ({
  'word_document':
      [
          flatpak_repo_path,
          'org.onlyoffice.desktopeditors.desktop'
      ],
  'spreadsheet_document':
      [
          flatpak_repo_path,
          'org.onlyoffice.desktopeditors.desktop'
      ],
  'presentation_document':
      [
          flatpak_repo_path,
          'org.onlyoffice.desktopeditors.desktop'
      ],
  'pdf_viewer':
      [
          standard_repo_path,
          'org.gnome.Evince.desktop'
      ],
  'text_editor':
      [
          standard_repo_path,
          'nvim.desktop'
      ],
  'image_viewer':
      [
          standard_repo_path,
          'org.gnome.gThumb.desktop'
      ],
  'image_editor':
      [
          standard_repo_path,
          'gimp.desktop'
      ],
  'video_player':
      [
          standard_repo_path,
          'io.github.celluloid_player.Celluloid.desktop'
      ],
  'web_browser':
      [
          standard_repo_path,
          'librewolf.desktop'
      ],
  'file_manager':
      [
          standard_repo_path,
          'thunar.desktop'
      ],
  'archive_manager':
      [
          standard_repo_path,
          'org.kde.ark.desktop'
      ],
})%}

{{ slsdotpath }}_copy_mimeapps_list_file:
  file.managed:
    - name: /usr/share/applications/mimeapps.list
    - source: salt://{{ slspath }}/mimeapps.list
    - template: jinja
    - user: root
    - group: root
    - mode: '0644' # I would usually set it to Read-only but as applications may change it \_("v")_/
    - defaults:
# Pass correct preferred application variables
# If desktop file exits => application installed => custom value for mimeapp
# Else set default app value
{% for variable, desktop_file_name in preferred_applications.items() %}
  {% set desktop_file_path = "/usr/share/applications/" ~ desktop_file_name %}
  {% set app =
    desktop_file_path
    if salt['file.file_exists'](desktop_file_path)
    else default_app
  %}
      {{ variable }}: {{ desktop_file_name }}
{% endfor %}
