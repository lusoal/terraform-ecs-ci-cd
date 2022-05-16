output "alb_tg_arn" {
  value = "${var.protocol == "TCP" ? element(concat(aws_lb_target_group.tg_tcp.*.arn,  tolist([""])), 0) : element(concat(aws_lb_target_group.tg.*.arn,  tolist([""])), 0)}"
}
