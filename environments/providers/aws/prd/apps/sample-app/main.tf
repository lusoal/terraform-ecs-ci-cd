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

# ECR Repo for the application

module "ecr" {
  source          = "terraform-aws-modules/ecr/aws"
  repository_name = var.app_name

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}


# LoadBalancer Resources
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${var.app_name}-alb-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.environment.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"] # Public LoadBalancer
}

module "application_loadbalancer" {
  source           = "../../../../../../modules/aws/alb/aws_lb"
  name             = "ecs-${var.app_name}"
  internal         = var.internal
  security_groups  = [module.alb_sg.security_group_id]
  internal_subnets = ["${module.environment.subnet_private_a}", "${module.environment.subnet_private_b}", "${module.environment.subnet_private_c}"]
  external_subnets = ["${module.environment.subnet_public_a}", "${module.environment.subnet_public_b}", "${module.environment.subnet_public_c}"]
  tags = {
    Name        = "${var.app_name}",
    environment = "${var.environment}"
  }
}

# Main Target Group and Listener
module "target_group" {
  source  = "../../../../../../modules/aws/alb/aws_lb_target_group"
  name    = "ecs-${var.app_name}"
  port    = var.target_group_port
  vpc_id  = module.environment.vpc_id
  path    = var.target_group_health_path
  matcher = var.target_group_matcher
}

module "loadbalancer_lister_http" {
  source            = "../../../../../../modules/aws/alb/aws_lb_listener"
  load_balancer_arn = module.application_loadbalancer.alb_arn
  target_group_arn  = module.target_group.alb_tg_arn
  port              = 80
  protocol          = "HTTP"
  ssl_certificate   = ""
  certificate_arn   = ""
}

# Test target Group and Listener
module "target_group_test" {
  source  = "../../../../../../modules/aws/alb/aws_lb_target_group"
  name    = "ecs-${var.app_name}-test"
  port    = var.target_group_port # Same port for target group
  vpc_id  = module.environment.vpc_id
  path    = var.target_group_health_path
  matcher = var.target_group_matcher
}

module "loadbalancer_lister_http_test" {
  source            = "../../../../../../modules/aws/alb/aws_lb_listener"
  load_balancer_arn = module.application_loadbalancer.alb_arn
  target_group_arn  = module.target_group_test.alb_tg_arn
  port              = 8080 # Different port for HTTP listener
  protocol          = "HTTP"
  ssl_certificate   = ""
  certificate_arn   = ""
}

# ECS Resources
module "task_definition" {
  source                 = "../../../../../../modules/aws/ecs/task_definition"
  family                 = var.family
  container_definitions  = data.template_file.task.rendered
  task_role_arn          = var.task_role_arn
  execution_role_arn     = var.execution_role_arn
  fargate_compatibilitie = var.fargate_compatibilitie
}

module "service_ecs_blue" {
  source                 = "../../../../../../modules/aws/ecs/service_create_with_scaling"
  fargate_compatibilitie = "Ec2"
  name                   = var.app_name
  cluster_id             = data.aws_ecs_cluster.ecs_cluster.arn
  task_definition        = "${module.task_definition.family_ec2}:${data.aws_ecs_task_definition.sample-app.revision}"
  deployment_controller  = "CODE_DEPLOY"
  desired_count          = 1
  launch_type            = "EC2"
  target_group_arn       = module.target_group.alb_tg_arn
  container_name         = var.app_name
  container_port         = 80
  predefined_metric_type = var.predefined_metric_type
  cluster_name           = var.cluster_name
  max_capacity           = var.max_capacity
  min_capacity           = var.min_capacity
  role_arn               = var.ecs_scaling_role_arn
  tags = {
    Name        = "${var.app_name}",
    environment = "${var.environment}"

  }
}

//Template because inside json have variables
data "template_file" "task" {
  template = file("./files/service.json")

  vars = {
    app_name = "${var.app_name}"
  }
}