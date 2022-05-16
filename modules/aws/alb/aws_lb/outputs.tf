output "alb_arn" {
  value = "${tobool(var.internal) == true ? element(concat(aws_lb.lb_internal.*.arn,  tolist([""])), 0) : element(concat(aws_lb.lb_external.*.arn,  tolist([""])), 0)}"
}

output "dns_name" {
  value = "${tobool(var.internal) == true ? element(concat(aws_lb.lb_internal.*.dns_name,  tolist([""])), 0) : element(concat(aws_lb.lb_external.*.dns_name,  tolist([""])), 0)}"
}
