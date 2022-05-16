resource "aws_ecs_service" "service_ec2" {
  count                             = "${var.fargate_compatibilitie == "Ec2" ? 1 : 0}"
  name                              = "${var.name}"
  cluster                           = "${var.cluster_id}"
  task_definition                   = "${var.task_definition}"
  desired_count                     = "${var.desired_count}"
  launch_type                       = "${var.launch_type}"
  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"

  deployment_controller {
    type = var.deployment_controller
  }

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "${var.container_name}"

    #Port of configured container in task definition json
    container_port = "${var.container_port}"
  }
}

resource "aws_ecs_service" "service_fargate" {
  count                             = "${var.fargate_compatibilitie == "Fargate" ? 1 : 0}"
  name                              = "${var.name}"
  cluster                           = "${var.cluster_id}"
  task_definition                   = "${var.task_definition}"
  desired_count                     = "${var.desired_count}"
  launch_type                       = "${var.launch_type}"
  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"

  deployment_controller {
    type = var.deployment_controller
  }

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "${var.container_name}"

    #Port of configured container in task definition json
    container_port = "${var.container_port}"
  }

  #Subnets and security groups to "place" my ecs instance fargate
  network_configuration {
    security_groups  = ["${var.security_groups}"]
    subnets          = ["${var.subnets}"]
    assign_public_ip = true
  }
}
