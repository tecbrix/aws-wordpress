module "vpc" {
  source = "github.com/tecbrix/aws-vpc"
#tag
  name = "wordpress"
  env  = "test"
}

module "rds" {
    depends_on = [
      module.vpc
    ]
  source = "github.com/tecbrix/aws-rds"
  mysql_sec_id = module.vpc.mysql_sec_id
  password = "Rds#admin=55"
#tag
  name = "wordpress"
  env  = "test"
}

module "ec2" {
    depends_on = [
      module.rds
    ]
  source = "github.com/tecbrix/aws-ec2"
  userdata = "files/userdata.sh"
  subnet_id = module.vpc.pub_subnet_for_ec2
  web_sec_id = module.vpc.web_sec_id
  db_pwd     = "Rds#admin=55"
  db_name     = module.rds.rdsdb
  db_user     = module.rds.rdsuser
  db_host     = module.rds.rdshost
#tag
  name = "wordpress"
  env  = "test"
}