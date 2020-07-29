provider "aws" {
  region   = "ap-south-1"
  profile  = "amarProfile"
}

resource "aws_key_pair" "task1" {
  key_name   = "rhelkey-file"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDILLaByMJKxqZvoCgbrVM4IR/A0EwP8/f/BC7gXddtPwg1FA7kWlJ+8qXcUTwCZPdqu/fPrx1pv+jU7SuCmVCRNuKuP/xCCnt6aI26z7eKkPkNPLpj1fYLVLwZs3nlrutf8YttYneDbTg71JwezyPDx0ABShFz8KeFmTt4rCXeN9OzG089q2UQrvkGz4qrtegQY+6vmtu7yLQdoPMTAueHCYHSZksaFIGlmpGhaAT0JmbDbA4QZRcdTgMC8NpFAu9RY5D1m56hgpUfufRRT4/3TNCvsUKXUu7BERKu0/j7TNTKTU/2uYqMXwNftcEau+NuqBO8hVHpAlo3vHuXLYux"
}

resource "aws_security_group" "task1-securitygroup" {
  name        = "task1-securitygroup"
  description = "Allow SSH AND HTTP"
  vpc_id      = "vpc-b66c70de"


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

  tags = {
    Name = "task1-securitygroup"
  }
}

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

resource "aws_cloudfront_distribution" "imgcloudfront" {
    origin {
        domain_name = "task1.s3.amazonaws.com"
        origin_id = "S3-task1" 


        custom_origin_config {
            http_port = 80
            https_port = 80
            origin_protocol_policy = "match-viewer"
            origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"] 
        }
    }
       
    enabled = true


    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "S3-task1"


        # Forward all query strings, cookies and headers
        forwarded_values {
            query_string = false
        
            cookies {
               forward = "none"
            }
        }
        viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }
    # Restricts who is able to access this content
    restrictions {
        geo_restriction {
            # type of restriction, blacklist, whitelist or none
            restriction_type = "none"
        }
    }


    # SSL certificate for the service.
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

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
}
  
resource "aws_instance" "task1" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name      = var.rhelkey-file
  security_groups = [ "task1-securitygroup" ]
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
             
  EOF

  tags = {
    Name = "task1"
  }
}
