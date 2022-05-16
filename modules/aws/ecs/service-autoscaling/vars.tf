variable "max_capacity" {}

variable "min_capacity" {
  default = 1
}

variable "role_arn" {
  description = "The IAM role that authorizes Amazon ECS to use Service Auto Scaling."
}

variable "name" {}

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

variable "app_name" {
  description = "Name of application"
}

variable "cluster_name" {
  description = "The name of the cluster to create the service in"
}
