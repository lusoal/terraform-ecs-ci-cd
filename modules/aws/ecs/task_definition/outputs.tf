output "family_ec2" {
  value = "${element(concat(aws_ecs_task_definition.task_definition_ec2.*.family, tolist([""])), 0)}"
}

output "family_fargate" {
  value = "${element(concat(aws_ecs_task_definition.task_definition_fargate.*.family, tolist([""])), 0)}"
}
