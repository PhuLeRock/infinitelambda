#aws_profile = "nashtechdevops" # here is the aws profile that you define by yourself in ~/.aws/credentials
aws_profile = "default"
aws_region        = "ap-southeast-1" #singapore

#db_instance_class = "db.t2.micro"
#dbname            = "devopstestdb"
#dbuser            = "nashtechdevops"
#dbpassword        = "nashtechdevopspass"
key_name          = "phule"
public_key_path   = "/Users/tam/Documents/repo/infinitelambda/devopstest/id_rsa.pub"
private_key_path  = "/Users/tam/Documents/repo/infinitelambda/devopstest/phultv.rsa"
micro_instance_type = "t2.micro"
#large_instance_type = "t2.medium"
amazonlinux_ami           = "ami-048a01c78f7bae4aa" #Amazon Linux 2 AMI (HVM), SSD Volume Type  for singapore
#amazonlinux_ami           = "ami-0b69ea66ff7391e80" #Amazon Linux 2 AMI (HVM), SSD Volume Type  for virginnia
localip = "0.0.0.0/0"
cidrs = {
  public1  = "172.16.1.0/24"
  public2  = "172.16.2.0/24"
  private1 = "172.16.3.0/24"
  private2 = "172.16.4.0/24"
  rds1     = "172.16.5.0/24"
  rds2     = "172.16.6.0/24"
  rds3     = "172.16.7.0/24"
}

