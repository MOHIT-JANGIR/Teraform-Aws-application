# Teraform-Aws-application
How to do it?

Prerequisite: You must have AWS-CLI and git installed.

1. Configure the Provider

2. Create Key Pair

Here we have used resource ‘tls_private_key’ to create private key saved locally with the name ‘webserver_key.pem’. Then to create ‘AWS Key Pair’ we used resource ‘aws_key_pair’ and used our private key here as public key.

3. Create a Security Group

We want to access our website through HTTP protocol so need to set this rule while creating a Security group. Also, we want remote access of instances(OS) through ssh to configure it.

Ingress rules are for the traffic that enters the boundary of a network. Egress rules imply to traffic exits instance or network. Configuring security group to allow ssh and http access.

4. Launch EC2 instance

We want to deploy our website on EC2 instance so that we need to launch an instance with installed servers and other dependencies. for that, we create an instance and downloading https, PHP, git to configure it.
We have created an instance in the Security group with amazon Linux(ami-0447a12f28fddb066), type of ‘t2.micro’, and keypair that we have created above. We have used Provisioner.
5. Create EBS Volume

Why we need EBS volume? We want to store code in persistent storage so that instance termination could not affect it
To attach a volume to EC2 instance it must be in the same availability zone of instance. Here size is 1GB. and a tag is ‘webserver-pd’.

6. Attach EBS volume to EC2 instance.

Our requirement is to copy code into EBS volume for that we need to attach EBS volume to EC2 instance.
This resource has dependency on EBS volume and instance. Because until they are not created we can not attach them. while destroying if the volume is attached to the instance we can not destroy it gives ‘volume is busy’ error. for that, we used force_detach = true.
7. Create S3 Bucket
We used terraform’s resource ‘aws_s3_bucket’ to create a bucket. To create a s3 bucket you must give a unique name to the bucket. ‘Here’s bucket name is ‘website-images-res’.

8. Add Object into S3

here in my case, I want to upload images from GitHub into the S3 bucket. I have used local-provisioner to download images from GitHub locally and then upload it to the S3 bucket.

9.Create CloudFront for S3
We created CloudFront distribution for our s3 bucket that we have created early

10.creating code of web server
what we are doing here is reading a file which will have CloudFront URL.

11. Time to Deploy Code

We want to download our code from the git repository into the document root in our case /var/www/html. and store CloudFront URL into path.txt. so images can be accessed via CloudFront.

12.OUTPUT
here we run terraform init and apply cmd

The public address will be print on the terminal copy that and paste in browser


  

 

  

    



  



