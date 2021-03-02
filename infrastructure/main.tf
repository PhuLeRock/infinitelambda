provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_availability_zones" "available" {
}

#####
# VPC
#####
resource "aws_vpc" "vpc" {
  #cidr_block = "10.1.0.0/16"
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "devopstest"
  }
}

#################
#internet gateway
#################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

##############
# Route tables
##############

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["public2"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["private1"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["private2"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private2"
  }
}

resource "aws_subnet" "rds1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["rds1"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "rds1"
  }
}

resource "aws_subnet" "rds2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["rds2"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "rds2"
  }
}

resource "aws_subnet" "rds3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["rds3"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "rds3"
  }
}




#####################
# Subnet Associations
#####################

resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_db_subnet_group" "rds_subnetgroup" {
  name       = "rds_subnetgroup"
  subnet_ids = [aws_subnet.rds1.id,aws_subnet.rds2.id,aws_subnet.rds3.id]

  tags = {
    Name = "rds_sng"
  }
}

################
#Security groups
################

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "Used for access to the dev instance"
  vpc_id      = aws_vpc.vpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public_sg" {
  name        = "sg_public"
  description = "Used for public and private instances for load balancer access"
  vpc_id      = aws_vpc.vpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#######################
#Private Security Group
#######################

resource "aws_security_group" "private_sg" {
  name        = "sg_private"
  description = "Used for private instances"
  vpc_id      = aws_vpc.vpc.id

  # Access from other security groups

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###################
#RDS Security Group
###################
resource "aws_security_group" "RDS" {
  name        = "sg_rds"
  description = "Used for DB instances"
  vpc_id      = aws_vpc.vpc.id

  # PostgreSQL access from public/private security group

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.dev_sg.id, aws_security_group.public_sg.id, aws_security_group.private_sg.id]
  }
}
###
#ECR
###
resource "aws_ecr_repository" "registry" {
  name                 = "ecr001"
  image_tag_mutability = "MUTABLE"
  tags = {
    Owner       = "DevopsTest"
    Environment = "dev"
    Terraform   = true
  }
}

###
# S3 website
###
resource "aws_s3_bucket" "staticweb" {
  bucket = "infinitedevopstest"
  acl    = "public-read"
  #policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

####
#RDS
####
resource "aws_db_parameter_group" "my-parameter-group" {
  name        = "my-parameter-group"
  family      = "postgres12"
  description = "my-parameter-group"
}

module "aws_rds_postgres" {
  source = "./modules/rds-ssm-postgres"
  identifier             = "rds-identifier"
  subnet_group           =  aws_db_subnet_group.rds_subnetgroup.id
  parameter_group        = "my-parameter-group"
  vpc_security_group_ids = [aws_security_group.RDS.id]
  monitoring_interval = 0
  deletion_protection = false
  tags = {
    Name = "DB"
  }
}


##########
# key pair
##########

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

########
# server
########

resource "aws_instance" "dev" {
  instance_type = var.micro_instance_type
  ami           = var.amazonlinux_ami

  tags = {
    Name = "micro-instance"
  }

  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id
  provisioner "local-exec" {
    command = "echo '[dev]' > aws_hosts && echo ${aws_instance.dev.public_ip} >>  aws_hosts"
  }

 provisioner "local-exec" {
   command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.dev.id} --profile ${var.aws_profile} --region ${var.aws_region} && ansible-playbook -i aws_hosts ansible_jenkins.yaml --private-key ${var.private_key_path}"
 }
}

############################
#-------OUTPUTS ------------
############################

#output "Database_Name" {
#  value = var.dbname
#}

# output "Database_Hostname" {
#  value = aws_db_instance.db.endpoint
# }

#output "Database_Username" {
#  value = var.dbuser
#}

#output "Database_Password" {
#  value = var.dbpassword
#}

output "Jenkins" {
  value = "http://${aws_instance.dev.public_ip}:3389"
}
#ansible-playbook -i aws_hosts jenkins.yaml --private-key /home/phuletv/phultv_np.rsa
output "website_URL" {
  value = "http://${aws_s3_bucket.staticweb.website_endpoint}"
}
output "ECR_url" {
  value= aws_ecr_repository.registry.repository_url
}

