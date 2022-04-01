# Wordpress Terraform module

Terraform module which creates RDS instance,ec2, associated vpc and install Wordpress.

### Module Usage
```
module "wordpress" {
  source = "github.com/tecbrix/aws-wordpress"
  name = "wordpress"
  env  = "test"
}
```
