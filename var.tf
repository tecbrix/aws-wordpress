locals {
  region = "eu-west-1"
}

variable "name" {
  default = "wordpress"
}

variable "db_psw" {
  default = "Rds#admin=55"
}

variable "db_name" {
  default = "wordpressdb"
}

variable "username" {
  default = "tecadmin"
}

variable "port" {
  default = "3306"
}