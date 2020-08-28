#!/bin/bash

# this section will create the needed directory
if [[ ! -d /etc/ansible/plays/ ]];
  then
    mkdir -p /etc/ansible/plays/
  fi

# this section will install the playbooks
echo " "
echo "grabbing the YAML files from the web"
  curl https://raw.githubusercontent.com/DavidHoenisch/Elk-Stack-Cloud-Deployment/master/Yaml_Files/filebeat_playbook.yml > /etc/ansible/filebeat_playbook.yml
  curl https://raw.githubusercontent.com/DavidHoenisch/Elk-Stack-Cloud-Deployment/master/Yaml_Files/metricbeat_playbook.yml > /etc/ansible/metricbeat_playbook.yml
  curl https://raw.githubusercontent.com/DavidHoenisch/Elk-Stack-Cloud-Deployment/master/Scripts/Multiplay.sh > /etc/ansible/Multiplay.sh
echo " "
echo "the yaml files have been successfully downlaoded"
echo " "

# this section will ask them to edit the hosts files first before proceeding
read -p "it is important to edit the hosts file first! Have you done so?(yes/no): " hosts

if [[ $hosts == "no" ]];
then
        echo "please edit the host file and then rerun the script with sudo"
        echo " "
        sleeps 1s
        echo "dropping you into nano on the hosts file now"
        nano /etc/ansible/hosts
fi


#this section will make the multiplay script exicutable
echo "making the multiplay script exicutable"
  chmod u+x /etc/ansible/Multiplay.sh
  echo " "
echo "the script have been given the 'x' bit"
sleep 1s
echo " "

# this section ask the user to choose a playbook to run
echo "[1] run the filebeat playbook"
echo "[2] run the metricbeat playbook"
echo "[3] run the multiplay script (installs both)"
echo " "
read -p "please choose an option from above (1, 2, 3)?: " number

if [[ $number == "1" ]];
then
      ansible-playbook /etc/ansible/filebeat_playbook.yml
      echo "install complete, exiting..."
      exit
fi

if [[ $number == "2" ]];
then
      ansible-playbook /etc/ansible/metricbeat_playbook.yml
      echo "install complete, exiting..."
      exit
fi

if [[ $number == "3" ]];
then
      ./etc/ansible/Multiplay.sh
      echo "install complete, exiting..."
      exit
fi
