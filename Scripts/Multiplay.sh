#!/bin/bash

ansible-playbook filebeat_playbook.yml
ansible-playbook metricbeat_playbook.yml
echo "elk stack install complete!"
