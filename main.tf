module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "wordpress-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.51.0/24", "10.0.52.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = {
    Owner       = "user"
    Environment = "test"
    Terraform   = "true"
  }

  vpc_tags = {
    Name = var.name
  }
}

module "db" {
  depends_on = [
    aws_security_group.mysql
  ]
  source  = "terraform-aws-modules/rds/aws"

  identifier = var.name

  engine            = "mysql"
  engine_version    = "5.7.25"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  create_random_password = false

  db_name  = var.db_name
  username = var.username
  password = var.db_psw

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.mysql.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  create_monitoring_role = false

  tags = {
    Owner       = "user"
    Environment = "test"
    name        = var.name
    Terraform   = "true"
  }

  # DB subnet group
  db_subnet_group_name = module.vpc.database_subnet_group_name
  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

module "ec2" {
    depends_on = [
      module.db
    ]
  source = "github.com/tecbrix/aws-ec2"
  userdata = "files/userdata.sh"
  subnet_id = tolist(module.vpc.public_subnets)[0]
  web_sec_id = aws_security_group.web.id
  db_pwd     = var.db_psw
  db_name     = var.db_name
  db_user     = var.username
  db_host     = module.db.db_instance_address
#tag
    env       = "test"
    name        = var.name
}