variable "port" {}

variable "to_port" {}

variable "protocol" {
  default = "tcp"
}

variable "ips_sg_list" {
}

variable "security_group_id" {}
