#!/bin/bash

# this section will check for root privs
if [[ $UID -ne 0 ]];
  then
    echo "this script will need to be run as sudo in order for it to run properly"
    exit
  fi
# this section will ask for the docker contianer name and start it
read -p "do you know the name of the container you would like to start?(yes/no): " answer
if [[ $answer == "no" ]];
  then
  sudo docker container list -a
fi
read -p "please enter the name of the container listed above that you would like to start: " container
docker container start  $container
sudo docker run -it $container curl https://raw.githubusercontent.com/DavidHoenisch/Elk-Stack-Cloud-Deployment/master/Scripts/simple_run_part2.sh > /tmp/simple_run_part2.sh
docker container attach $container

exit
