# VPC Variables
variable "vpc_name" {
  default = "test-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_nat_gateway" {
  default = true
}

variable "enable_vpn_gateway" {
  default = false
}

variable "tags" {
  default = {
    Terraform   = "true"
    Environment = "prd"
  }
}

# ECS variables
variable "ecs_name" {
  default = "ecs-prd"
}

# ASG Security Group

variable "sg_name" {
  default = "asg-ecs"
}

variable "sg_port" {
  default = 0
}

variable "to_port" {
  default = 65535
}

# ASG Variables

variable "asg_name" {
  default = "ecs-asg"
}

variable "min_size" {
  default = 3
}

variable "max_size" {
  default = 3
}

variable "desired_capacity" {
  default = 3
}

variable "health_check_type" {
  default = "EC2"
}

variable "image_id" {
  default = "ami-061c10a2cb32f3491"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  default = "ecs-demo-key"
}

variable "user_data" {
  default = "IyEvYmluL2Jhc2gKZWNobyAiRUNTX0NMVVNURVI9ZWNzLXByZCIgPj4gL2V0Yy9lY3MvZWNzLmNvbmZpZw=="
}

# TBD: Create that role using IaC
variable "iam_instance_profile_arn" {
  default = "arn:aws:iam::936068047509:instance-profile/ecs-ec2-role"
}

variable "asg_tag" {
  default = {
    Name = "ecs-instance-asg"
  }
}