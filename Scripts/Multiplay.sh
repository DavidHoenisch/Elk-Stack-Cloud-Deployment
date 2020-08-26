#!/bin/bash

asnible-playbook ./filebeat_playbook.yml
asnible-playbook ./metricbeat_install.yml
echo "elk stack install complete"
