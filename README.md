# NeuReality-Devops task 
Steps to run terraforn provisioning:

1. Set Variables in var.tf
You can change configuration of file var.tf, such as region, key name, ami, etc.

2. run terraform init -> terrafon plan -> terraform apply.

3. test ssh to Master/Slave with: ssh -i <key_name> ubuntu@<instance_IP>


Link to DockerHub image: https://hub.docker.com/r/avivzelevski/flask_app
