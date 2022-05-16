output "service_id_ec2" {
  value = "${element(concat(aws_ecs_service.service_ec2.*.id, list("")), 0)}"
}

output "service_id_fargate" {
  value = "${element(concat(aws_ecs_service.service_fargate.*.id, list("")), 0)}"
}
