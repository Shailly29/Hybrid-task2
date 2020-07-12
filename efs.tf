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
