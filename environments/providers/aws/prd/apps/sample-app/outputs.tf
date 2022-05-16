output "task_definition_revision" {
  value = "${module.task_definition.family_ec2}:${data.aws_ecs_task_definition.sample-app.revision}"
}