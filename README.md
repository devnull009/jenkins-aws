# This repository is for demonstration purposes
The aim of of the published code is to demonstrate how you can automate:

* IaC using Terraform
* CasC using Ansible
* Jenkins setup using JCasC

## Requirements

- AWS Free Tier Account
    - Generated identity for your zone using IAM
- AWS CLI
- GitHub account
    - Generated SSH key
- Hashicorp Terraform (0.12.20)
- Ansible (2.9.4)

## How to provision Jenkins on AWS

**Note:** Make sure you already have the identity downloaded from AWS. Keep this file safe as it allows you to connect to AWS without any password.<br>
**Note:** Your identity user should have:
* Policy for AdministratorAccess

### Step 1:

Download and install AWS CLI (Command Line Interface).<br>
For detailed guide: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install<br><br>
`cd /tmp`<br>
`curl -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip`<br>
`unzip awscliv2.zip`<br>
`sudo ./aws/install`<br>
`aws configure`<br><br>
Make sure the following fields (`aws_access_key_id`,`aws_secret_access_key`) have correct data.<br><br>
Example identity file `~/.aws/credentials`:<br>
`[identity_name]`<br>
`aws_access_key_id=your_id`<br>
`aws_secret_access_key=your_key`<br><br>
Basically, `aws configure` will do the same but in addition could add region in another file.

### Step 2:

Download and install HashiCorp Terraform.<br>
For detailed guide: https://www.terraform.io/downloads.html<br><br>

`cd /tmp`<br>
`curl -L https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip -o terraform.zip`<br>
`unzip terraform.zip`<br>
`sudo mv terraform /usr/local/bin/terraform`<br>
`sudo chmod +x /usr/local/bin/terraform`<br><br>

Now you could benefit of provided Terraform code in this Git repository.<br>
Go to the `terraform` directory and execute:<br>

`terraform init`<br>
`terraform plan`<br>
`terraform apply`<br><br>

**Note:** These scripts relies on pre-defined key pair for EC2 called `Kristiyan`. This is the private key used for authentication against all instances. Make sure to have it in advance.

To remove resources from AWS:<br>

`terraform destroy`

### Step 3:

Once your cloud environment is ready and you have the public IPs of each instance, make sure to write them down because they will be used for your Ansible inventory.<br>

Install Ansible through your repositories:<br>
`sudo apt install ansible -y`<br>
`sudo yum install ansible -y`<br>

Go to the `ansible` directory and edit `inv` file. This means to configure properly variables for `ansible_host` with public IPs from Terraform.<br>
Make sure to provide following environment variables:<br>
`export ANSIBLE_HOST_KEY_CHECKING=false`<br>
`export PKEY=/path/to/my/private/keypair.file`

#### Provision Docker
For BECOME password leave the field empty and just press enter.<br>
`ansible-playbook --private-key=$PKEY -i inv docker.yml -K`

#### Provision Jenkins files
`ansible-playbook --private-key=$PKEY -i inv jenkins.yml`

#### Secure instances
For BECOME password leave the field empty and just press enter.<br>
`ansible-playbook --private-key=$PKEY -i inv secure.yml -K`

#### SSH into each AWS instances
As you can tell, since these instances are re-usable and we have custom Jenkins image, we have to build it first.<br>

SSH into master instance:<br>
`ssh -i $PKEY <Master IP here> -l ubuntu`<br>
`cd /tmp/jenkins`<br>
`. build.sh`<br>
`. run.sh`<br>

**Note:** This will build and run a Docker image with custom Jenkins with pre-defined configuration. The username could be found in JCasC file while the password could be found by running `echo $KRIS_PWD` command.<br>
Now, your Jenkins master is available on the public IP, port 8080.<br>

**Note:** You might want to press Ctrl+C to stop tailing the log from running container.

#### How we connect each Jenkins slave?

First, you need to open Jenkins at port 8080. Then navigate to Manage Jenkins -> Manage Nodes. Select first slave called - slave1.<br>

Now SSH into first slave public ip and modify the following file:<br>
`cd /tmp/jenkins-slave`<br>
`nano env.txt`<br>
* **url** - Jenkins URL with port (change that)
* **node** - This should be called slave1, as this is stated in JCasC
* **secret** - Paste the secret from Jenkins UI into the file and save it <br>

`. build.sh`<br>
`. run.sh`<br>

**Note:** You might want to press Ctrl+C to stop tailing the log from running container. <br>
**Note:** Procedure is exactly the same every slave.<br>
