resource "aws_ecs_task_definition" "task_definition_ec2" {
  count        = "${var.fargate_compatibilitie == "Ec2" ? 1 : 0}"
  family       = "${var.family}"
  network_mode = "${var.network_mode}"

  #Just the container definition to be created
  container_definitions = "${var.container_definitions}"

  task_role_arn         = "${var.task_role_arn}"
  execution_role_arn    = "${var.execution_role_arn}"

  #fargate or ec2
  requires_compatibilities = "${var.requires_compatibilities}"
}

resource "aws_ecs_task_definition" "task_definition_fargate" {
  count        = "${var.fargate_compatibilitie == "Fargate" ? 1 : 0}"
  family       = "${var.family}"
  network_mode = "${var.network_mode}"

  #Just the container definition to be created
  container_definitions = "${var.container_definitions}"
  task_role_arn         = "${var.task_role_arn}"
  execution_role_arn    = "${var.execution_role_arn}"

  #fargate or ec2
  requires_compatibilities = "${var.requires_compatibilities}"
  memory                   = "${var.memory}"
  cpu                      = "${var.cpu}"
}
