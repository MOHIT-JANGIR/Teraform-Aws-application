# Teraform-Aws-application
What is Terraform?

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. Configuration files describe to Terraform the components needed to run a single application or your entire datacenter.

What is AWS cloud?

Amazon Web Services (AWS) is the world’s most comprehensive and broadly adopted cloud platform, offering over 175 fully featured services from data centers globally. Millions of customers—including the fastest-growing startups, largest enterprises, and leading government agencies—are using AWS to lower costs, become more agile, and innovate faster.

Description of Task :

Task : we have to create or launch application using Trraform.

1. Create the key and security group which allow the port 80.

2. Launch EC2 instance.

3. In this Ec2 instance use the key and security group which we have created in step 1.

4. Launch one Volume (EBS) and mount that volume into /var/www/html

5. Developer have uploded the code into github repo also the repo has some images.

6. Copy the github repo code into /var/www/html

7. Create S3 bucket, and copy/deploy the images from github repo into the s3 bucket and change the permission to public readable.

8 Create a Cloudfront using s3 bucket(which contains images) and use the Cloudfront URL to update in code in /var/www/html

Install and setup terraform in your system.

For the first time you have to use terraform init to initialize.

Then we have to create a file with .tf extension using any editor and terraform.

STEP 1: Security Groups : This will use to create our security group for launching the instances.

resource "aws_security_group" "task1-securitygroup" {

  name        = "task1-securitygroup"

  description = "Allow SSH AND HTTP"

  vpc_id      = "vpc-b66c70de"

STEP 2: Create the key and security group which allow the port 80.

This code is basically used for allowing the SSH from port 22 and HTTP port 80

  ingress {

    description = "SSH"

    from_port   = 22

    to_port     = 22

    protocol    = "tcp"

    cidr_blocks = [ "0.0.0.0/0" ]

  }

  ingress {

    description = "HTTP"

    from_port   = 80

    to_port     = 80

    protocol    = "tcp"

    cidr_blocks = [ "0.0.0.0/0" ]

  }

  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

STEP 3: Launching the Ec2 instance : in this Ec2 instance use the key and security group which we have created by the below code

resource "aws_instance" "task1" {

  ami           = "ami-0447a12f28fddb066"

  instance_type = "t2.micro"

  availability_zone = "ap-south-1a"

  key_name      = var.rhelkey-file

  security_groups = [ "task1-securitygroup" ]

  user_data = <<-EOF

No alt text provided for this image

STEP 4 :  Launch one Volume (EBS) and mount it into /var/www/html : this code will use to launch and mount the EBS volume.

resource "aws_ebs_volume" "task1" {

  availability_zone = "ap-south-1a"

  size              = 1

  tags = {

    Name = "Task1"

  }

}

resource "aws_volume_attachment" "task1" {

 device_name = "/dev/sdf"

 volume_id = aws_ebs_volume.task1.id

 instance_id = aws_instance.task1.id

}

variable "rhelkey-file"{

      type = string

      default = "rhelkey-file"

No alt text provided for this image

STEP 5 : Developer have uploded the code into github repo .

 user_data = <<-EOF

                #! /bin/bash

                sudo yum install httpd -y

                sudo systemctl start httpd

                sudo systemctl enable httpd

                sudo yum install git -y

                mkfs.ext4 /dev/xvdf1

                mount /dev/xvdf1 /var/www/html

                

                git clone 

https://github.com/Amar-tiwary18/HMC_Task1.git

cd Hybrid-Task1

cp index.html /var/www/html

             

 STEP 6: Create S3 bucket: code for the my s3 bucket is below:

resource "aws_s3_bucket" "task1" {

    bucket = "automatebucket1"

    acl    = "public-read"

    tags = {

Name    = "task1"

Environment = "Dev"

    }

    versioning {

enabled =true

    }

}

No alt text provided for this image

STEP 7:  Create a Cloudfront using s3 bucket(which contains images) and use the Cloudfront URL to update in code in /var/www/html

No alt text provided for this image

Finally the webpage I created is deployed.

No alt text provided for this image

