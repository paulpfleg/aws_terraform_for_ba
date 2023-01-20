# Terraformcode for Cloud Encoder

The code provides the infrastructure for a cloud encoder on AWS.

The project's purpose is to transcode Video files, stored in a S3 Bucket using EC2 Instances.
Therefore, it uses the node.js Servers provided under: https://github.com/paulpfleg/deploy.
These apps, wrap parameter handed over via a UI in ffmpeg commands.
The conversion's result is then stored in the S3 Bucket.
Furthermore, the apps provide the option to manage the S3-Buckt's content.

It generates three kinds of servers:
A proxy with nginx and ha-proxy, for reverse proxy and load balancing functionalities,
A frontend server, to offer a UI
and backend servers, to convert file

## Quickstart 

To start using the code, you should follow these steps:
* make sure the latest version of terraform is installed
* install aws cli 
* in the aws_terraform_for_ba folder, create an enviroments.tfvars file with the following contents:

* * access_key = "YOUR_AWS_ACESS_KEY"
* * secret_key = "YOUR_SECRET_AWS_ACESS_KEY"

* * public_key  = "/path/to/ssh/key"
* * private_key = "/path/to/private/ssh/key"

* make sure the predefined values under variables.tf fit your needs
* roll out the infrastructure by typing the following command i a terminal located in the aws_terraform_for_ba folder
terraform apply -var-file=enviroments.tfvars -auto-approve

## Note 

* the code was tested under MacOS 12.3
* configurations for local provisions may differ in other OS's
* those configs could be adjusted under local exec.tf and output.tf

