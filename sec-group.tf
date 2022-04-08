resource aws_security_group "web" {
depends_on = [
  module.vpc
]
  name        = "${var.name}-web"
  description = "This is for ${var.name}s web servers security group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name}-web"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource aws_security_group "mysql" {
 depends_on = [
  module.vpc
 ]
  name        = "${var.name}-db"
  description = "managed by terrafrom for db servers"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.name}-db"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.web.id]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}