variable "app_name" {
  
}

variable "deployment_config_name" {
  default = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"
}

variable "ecs_service_name" {
  description = "Name of the ECS service to deploy"
}

variable "termination_wait_time_in_minutes" {
  default = 30
}

variable "ecs_cluster_name" {
  
}

variable "main_listener" {
  description = "Listener of the ALB"
}

variable "main_target_group" {
  
}

variable "test_target_group" {
  
}

variable "test_listener" {
  
}