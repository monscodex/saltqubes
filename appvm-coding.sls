{% if grains['nodename'] == 'dom0' %}


{% from 'common-appvms/development/dom0_expand_storage.jinja' import expand_storage_for_development_if_needed %}


{% set free_space_object = namespace(value=0) %}

# USAGE: Call {{ expand_storage_for_development_if_needed }} with arguments DESIRED_APPVM, free_space_object)


{% else %}


include:
  - common-appvms.development


{% endif %}
