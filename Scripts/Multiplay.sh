#!/bin/bash

echo "runnning the multiplay script"
sleep 1s
echo " "
echo "after completing, filebeat & metricbeat will be installed"
echo " "
sleep 1s
read -p "do you wish to continue(yes/no)?: " answer
if [[ $answer == "no" ]];
  then
    echo "exiting..."
    sleep 1s
    exit
  fi
ansible-playbook filebeat_playbook.yml || echo "error occured"
ansible-playbook metricbeat_playbook.yml || echo "error occured"
echo " "
echo "go to the web server address to verify that filebeat and metricbeat are working correctly"
echo " "
sleep 1s
echo "exiting..."
