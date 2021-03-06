provider "aws" {

region = "ap-south-1" profile = "shailly_shah"
}

//CREATING A KEY PAIR
resource "aws_key_pair" "taskkey1" {
 
key_name	= "taskkey1"

public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUq/YAlVDk0LJnrX700LphB194pc5ceH6nLDAsz3
9AmFSaIvkq6s+nW6TgL0OV5llI57RGCQvNIMTxxeVC1eWgP7wYqD+qDxX8OgykDAdeKGjZ1 jbuss67ucm10NeaHoiUwPPFEBgF7+B7VQSGLuSpYjn54D39JbortLbeYCfPl5WctgN1ejOQ3m ois+fb0qsr39B8taj6WzxE4eQbKOdq9TXCKPwMsdXtiqRXEuYrscwTGapRTkwt5fBFiW5r26au UzL5NO/wDWjPxkYOVIvkMi1+zqgguplJ4Rl9zlEj4TZod5N+5sJOLqLvhTP8tCs7rnckHvuROYq 3EFxnNJ+3"

}

//CREATING A SECURITY GROUP
resource "aws_security_group" "tasksg1" { name	= "tasksg1"
description = "Allow TLS inbound traffic" vpc_id	= "vpc-377c605f"




ingress {

description = "SSH" from_port = 22
to_port	= 22 protocol		= "tcp"
cidr_blocks = [ "0.0.0.0/0" ]

}



ingress {

description = "HTTP" from_port = 80
 
to_port	= 80 protocol		= "tcp"
cidr_blocks = [ "0.0.0.0/0" ]

}



egress { from_port = 0
to_port	= 0

protocol	= "-1" cidr_blocks = ["0.0.0.0/0"]
}



tags = {

Name = "tasksg1"

}

}

//CREATING A EFS 

resource "aws_efs_file_system" "shaillynfs" { creation_token = " shaillynfs " 
tags = { 
Name = " shaillynfs " 
 } 
} 
resource "aws_efs_mount_target" "shah" { file_system_id="${aws_efs_file_system.shaillynfs.id}”
subnet_id = "${aws_subnet.shah.id}" 
security_groups = [ "${aws_security_group.nfs-sg.id}"
 ]
 }
 resource "aws_subnet" "shah" {
 vpc_id = "${aws_security_group.nfssg.vpc_id}"
 availability_zone = "ap-south-1a" 
cidr_block = "172.31.48.0/20" }
}

//CREATING OF INSTANCE
resource "aws_instance" "taskinst1" { ami	= "ami-0d855078e0e5b532c" instance_type = "t2.micro" availability_zone = "ap-south-1a" key_name	= "taskkey1" security_groups = [ "tasksg1" ] user_data = <<-EOF
#! /bin/bash

sudo yum install httpd -y sudo systemctl start httpd sudo systemctl enable httpd 
yum install -y amazon-efs-utils
apt-get -y install amazon-efs-utils
yum install -y nfs-utils
apt-get -y install nfs-common
file_system_id_1="${aws_efs_file_system.allownfs.id}"
efs_mount_point_1="/var/www/html"
mkdir -p "$efs_mount_point_1"
test -f "/sbin/mount.efs" && echo "$file_system_id_1:/
$efs_mount_point_1 efs tls,_netdev" >> /etc/fstab || echo
"$file_system_id_1.efs.ap-south-1.amazonaws.com:/
$efs_mount_point_1 nfs4
nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,
noresvport,_netdev 0 0" >> /etc/fstab
test -f "/sbin/mount.efs" && echo -e "\n[client-info]\nsource=liw" >>
/etc/amazon/efs/efs-utils.conf
mount -a -t efs,nfs4 defaults
sudo yum install git -y
 cd /var/www/html
sudo yum install git -y
mkfs.ext4 /dev/xvdf1
mount /dev/xvdf1 /var/www/html 
cd /var/www/html
git clone https://github.com/Shailly29/Hybrid-task2

EOF

tags =  
Name = "taskinst1"

}

}

//CREATING A S3 BUCKET


resource "aws_s3_bucket" "my-test-s3-terraform-bucket-shaillys3" { bucket = "my-test-s3-terraform-bucket-shaillys3"
tags = {

Name = "my-test-s3-terraform-bucket-shaillys3"

}

}



//CREATING A CLOUDFRONT


resource "aws_cloudfront_distribution" "s3_distribution" { origin {
domain_name ="${aws_s3_bucket.my-test-s3-terraform-bucket- shaillys3.bucket_regional_domain_name}"

origin_id ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.id}"

}

enabled = true is_ipv6_enabled = true comment = "S3 bucket" default_cache_behavior {
allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS",
 
"PATCH", "POST", "PUT"]

cached_methods = ["GET", "HEAD"]

target_origin_id ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.id}" forwarded_values {
query_string = false cookies {
forward = "none"

}

}

viewer_protocol_policy = "allow-all" min_ttl = 0
default_ttl = 3600

max_ttl = 86400

}

# Cache behavior with precedence 0 ordered_cache_behavior {
path_pattern = "/content/immutable/*" allowed_methods = ["GET", "HEAD", "OPTIONS"] cached_methods = ["GET", "HEAD", "OPTIONS"]
target_origin_id ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.id}" forwarded_values {
query_string = false cookies {
forward = "none"

}
 
}

min_ttl = 0

default_ttl = 86400

max_ttl = 31536000 compress = true
viewer_protocol_policy = "redirect-to-https"

}

restrictions { geo_restriction {
restriction_type = "whitelist" locations = ["IN"]
}

}

tags = {

Environment = "production"

}

viewer_certificate { cloudfront_default_certificate = true
}

depends_on = [

aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3

]

}
