{{ slsdotpath }}_delete_QT_SCALE_FACTOR_variable_in_etc_environment:
  cmd.run:
    - name: sed -i '/QT_SCALE_FACTOR/d' /etc/environment

{{ slsdotpath }}_append_QT_SCALE_FACTOR_to_etc_environment:
  file.append:
    - name: /etc/environment
    - text: "QT_SCALE_FACTOR=1.25"
