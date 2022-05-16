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

variable "max_capacity" {}

variable "min_capacity" {
  default = 1
}

variable "cluster_name" {
  description = "The name of the cluster to create the service in"
}

variable "role_arn" {
  description = "The IAM role that authorizes Amazon ECS to use Service Auto Scaling."
}

variable "policy_type" {
  default = "TargetTrackingScaling"
}

variable "predefined_metric_type" {
  default = "ECSServiceAverageCPUUtilization"
}

variable "target_value" {
  default = 70
}

variable "scale_in_cooldown" {
  default = 60
}

variable "scale_out_cooldown" {
  default = 30
}

variable "tags" {}

variable "propagate_tags" {
  default = "SERVICE"
}

variable "deployment_controller" {
  default = "ECS"
}