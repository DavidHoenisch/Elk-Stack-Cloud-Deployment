## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Net_Diagram](Images/Net_Diagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to recreate the entire deployment pictured above. Alternatively, select portions of the yaml file may be used to install only certain pieces of it, such as Filebeat.  I have chosen to leave these yml files separate to make it easier for less experienced users to deploy one or the other.  If you want to deploy both beats, I have written a basic bash script to automate that task.  You can find it in the Scripts Directory.

![install elk](Yaml_Files/install_elk.yml)
![install filebeat](Yaml_Files/filebeat_playbook.yml)
![install metricbeat](Yaml_Files/metricbeat_playbook.yml)


This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly resilient in addition to restricting unauthorized access to the network.
- Load balancers ensure that a network remains /available/ even  in the midst of heavy traffic or attempted DoS attacks.   

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system health.
- Filebeat allows security professionals to easily parse through logs files.  Filebeat acts as a "middle" man, monitoring logs and then forwarding along the ones that it was configured to.
- Metricbeat allows security professionals to monitor the health of their computer or servers.  Metricbeat will watch and record metrics such as CPU & RAM usage.

The configuration details of each machine may be found below.

| Name       | Function   | IP Address | Operating System     |
|------------|------------|------------|----------------------|
| Jump_Box   | Gateway    | 10.0.0.1   | Linux (Ubuntu 18.04) |
| Web_1      | Web_ser    | 10.0.0.9   | Linux (Ubuntu 18.04) |
| Web_2      | Web_ser    | 10.0.0.11  | Linux (Ubuntu 18.04) |
| ELK-SERVER | Elk stack  | 10.1.0.4   | Linux (Ubuntu 18.04) |

### Access Policies

The machines on the internal network are not exposed to the public Internet.

Only the Jump_Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- [insert public IP here] Nope, you don't get my public IP that easy, homies :)

Machines within the network can only be accessed by Jump_Box.
- The jump box acts as the node through which admins can access the network from the WAN.  It is also the only way to access the machines on the LAN.  Accessing Web_1 & Web_2 requires one to be inside the Ansible Docker container.  From that point one can also access the ELK server.  Access to all machines on the networked is secured through the use of SSH keys.

A summary of the access policies in place can be found in the table below.

| Name      | Publicly Accessible | Allowed IP Addresses |
|-----------|---------------------|-------------------------|
| Jump_Box  | No                  | [Insert your public IP] |
| Web_1     | No                  | Jump_box IP 10.0.0.4    |
| Web_2     | No                  | Jump_box IP 10.0.0.4    |
| Elk_Sever | No                  | [Insert your public IP] |

With the above access policies some clarification should be made.  None of the machines are "Publicly Accessible" in the sense that anyone can go to the url and get access to the servers.  They do however point WAN side.  The distinction is that WAN access is still restricted to a select pool of IP addresses, though they could be opened up to be accessed by anyone.  In regards to Web_1 & Web_2, access to them on the WAN side is not direct in the strictest sense.  The webservers sit in a pool behind a load balancer. As such when one wants to access the DVWA webservers they go to the load balancer address and then are directed to Web_1 or Web_2 from there.

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually.
- The advantage of this deployment process will largely be seen in larger companies and organizations where there are 2 or more servers that need to be configured and maintained.  This process will save on time, and will help eliminate as much human error as possible.

The playbook implements the following tasks:
- Install Docker.io
- Install Pip3
- Install Docker python module
- Increase virtual memory
- Download and launch ELK container

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![docker_ps output](Images/docker_ps.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- 10.0.0.11
- 10.0.0.9

We have installed the following Beats on these machines:
- Metricbeat
- Filebeat

These Beats allow us to collect the following information from each machine:
- Filebeat will collect log files (administrators can choose which they would like Filebeat to work on).  These logs will be stored in Logstash for further analysis.
- Metricbeat focuses on machine health and telemetry. It reports machine metrics back to the ELK Stack such as CPU load/usage as well as Memory.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned:

SSH into the control node and follow the steps below:
- Copy the install_elk.yml file to the /etc/ansible/ directory in you docker container.
- Update hosts file in the ansible directory to include the the IP address of the ELK server that you wish to run the yaml file on.
- Run the playbook and navigate to http://[IP_of_the_server]:5601/app/kibana to ensure that the install worked as expected.  

### Commands to complete the install
Completing this task will require some basic linux commands to get everything up and running.  If you are not familiar with the needed commands you can find them here:
- sudo docker container list -a (use this to find out what the name of your container is)
- sudo docker start [name of container] (this command starts the ansible container)
- sudo docker attach [name of container] (this command will drop you into an ansible container shell)
- cd /etc/ansible/ (this will take you to the directory where the ansible config files are as well as where we are going to put the playbooks)
- mkdir plays (this will create a folder in which we will store the playbooks)
- cd plays (this will bring us into the plays directory)
- curl [raw_link] > filebeat_install.yml
- curl [raw_link] > metricbeat_install.yml
- curl [raw_link] > multiplay.sh
- nano ../hosts (this will let you edit the hosts file in order to add in the correct IPs)
- When you are done, use ctrl+x and then the y key to save and exit.
- Making sure you are in your plays directory, run: ansible-playbook [playbook name] to run the play(s).
- If you would like to automate the process of running both, use: chmod u+x multiplay.sh to make the script executable.
- Then run ./multiplay.sh to install both beats.  Please note that you will want to run the script inside the plays folder.  If you don't then you will get incomplete file path errors.  

## Bonus Resources
In order to make your life even easier, I have supplied a bash script that will automate this entire process.  You will need to manually make the edits to the hosts file, but once that is done, you can run the simple_run_part1 in the jump box, and then simple_run_part2 in the elk container.  The simple run scripts have been tested to work, though for the time being, their user execution is a bit clunky.  The traditional way of running commands from outside a container, on the inside of a container, was not quite working just the way I wanted it to.  I am looking for a better option.  So, for the time being, just run the script (simple_run #1) inside the main machine.  At the end of the script, it will drop you into the Image you selected.  Once inside, use $: curl  https://raw.githubusercontent.com/DavidHoenisch/Elk-Stack-Cloud-Deployment/master/Scripts/simple_run_part2.sh > simple_run_part2.sh to get the second simple run script from my GitHub repo.  Then use $: chmod u+x simple_run_part2.sh to make it executable.  Once that is done use $: ./simple_run_part2.sh to run the script.  At that point just follow the on screen instructions and the rest of the work will be done for you.  Stay tuned for when I get a solution figured out to run both scripts as one!
![simple_run](Scripts/simple_run_part2.sh)
![simple_run](Scripts/simple_run_part2.sh)
