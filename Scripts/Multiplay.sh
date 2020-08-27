#!/bin/bash

ansible-playbook ./filebeat-playbook.yml
ansible-playbook ./metricbeat-playbook.yml
echo "elk stack install complete!"
