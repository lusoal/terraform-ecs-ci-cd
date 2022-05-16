# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# terraform {
#   backend "s3" {
#     region  = "sa-east-1"
#     bucket  = "enablers-team"
#     key     = "tf-states/IWS/GREMLIN.tfstate"
#     encrypt = true
#   }
# }

//Import the constants
module "environment" {
  source = "../"
}

# Resources using default aws modules
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = var.tags
}

# ECS Module to provision the cluster
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = var.ecs_name

  tags = var.tags
}

module "asg_sg" {
  source = "../../../../../modules/aws/create_sg"

  sg_name = var.sg_name
  vpc_id  = module.vpc.vpc_id
}

module "asg_sg_rule" {
  source            = "../../../../../modules/aws/create_sg_rule"
  port              = var.sg_port
  to_port           = var.to_port
  ips_sg_list       = [var.vpc_cidr]
  security_group_id = module.asg_sg.id
}

# AutoScaling Group for ECS

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.asg_name

  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  health_check_type   = var.health_check_type
  vpc_zone_identifier = module.vpc.private_subnets

  # Launch template
  launch_template_name        = "example-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true

  user_data                = var.user_data
  iam_instance_profile_arn = var.iam_instance_profile_arn

  image_id          = var.image_id
  instance_type     = var.instance_type
  ebs_optimized     = true
  enable_monitoring = true

  key_name = var.key_name

  security_groups = [module.asg_sg.id]

  tags = merge(var.tags, var.asg_tag)
}