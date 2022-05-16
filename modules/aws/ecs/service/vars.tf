variable "name" {}

variable "cluster_id" {}

variable "task_definition" {}

variable "desired_count" {
  default = 1
}

variable "launch_type" {
  default = "EC2"
}

variable "target_group_arn" {}

variable "container_name" {}

variable "container_port" {
  default     = 0
  description = "Default 0 to map any instance port to an application port in container definitions"
}

variable "security_groups" {
  default = ""
}

variable "subnets" {
  default = ""
}

variable "fargate_compatibilitie" {
  default     = false
  description = "Use true if your service uses AWS fargate"
}

variable "health_check_grace_period_seconds" {
  default = 120
}

variable "deployment_controller" {
  default = "CODE_DEPLOY"
}
