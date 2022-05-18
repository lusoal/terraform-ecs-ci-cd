variable "cluster_name" {
  default = "ecs-prd"
}

variable "family" {
  default = "sample-app"
}

variable "fargate_compatibilitie" {
  default = "Ec2"
}

variable "task_role_arn" {
  default = ""
}

variable "execution_role_arn" {
  default = "arn:aws:iam::ACCOUNT_ID:role/ecsTaskExecutionRole"
}

variable "app_name" {
  default = "sample-app"
}

variable "environment" {
  default = "prd"
}

variable "internal" {
  default = false
}

variable "target_group_port" {
  default = 80
}

variable "target_group_health_path" {
  default = ""
}

variable "target_group_matcher" {
  default = "200"
}

variable "predefined_metric_type" {
  default = "ECSServiceAverageCPUUtilization"
}

variable "max_capacity" {
  default = 5
}

variable "min_capacity" {
  default = 1
}

variable "desired_count" {
  default = 3
}

variable "ecs_scaling_role_arn" {
  default = ""
}

variable "deployment_controller" {
  default = "CODE_DEPLOY"
}

variable "desired_count" {
  var = 1
}

# Pipeline variables

variable "repo_name" {
  default = "sample-app"
  description = "CodeCommit repository name for my application"
}
