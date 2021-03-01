variable "aws_region" {
}

variable "aws_profile" {
}

variable "localip" {
}

#variable "db_instance_class" {
#}

#variable "dbname" {
#}

#variable "dbuser" {
#}

#variable "dbpassword" {
#}

variable "key_name" {
}

variable "public_key_path" {
}

variable "private_key_path" {
}

#variable "dev_instance_type" {
#}
#
#variable "dev_ami" {
#}

variable "micro_instance_type" {
}

#variable "large_instance_type" {
#}

variable "amazonlinux_ami" {
}

variable "cidrs" {
  type = map(string)
}
