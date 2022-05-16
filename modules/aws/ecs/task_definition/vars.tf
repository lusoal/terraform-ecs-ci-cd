variable "family" {}

variable "network_mode" {
  default = "bridge"
}

#Json of task definition
variable "container_definitions" {}

#arn para ecs chamar outros recursos da AWS
variable "task_role_arn" {
  default = ""
}

variable "execution_role_arn" {
  default = ""
}

variable "requires_compatibilities" {
  default = ["EC2"]
}

variable "memory" {
  default = 512
}

variable "cpu" {
  default = 256
}

variable "fargate_compatibilitie" {
  default = false
}
