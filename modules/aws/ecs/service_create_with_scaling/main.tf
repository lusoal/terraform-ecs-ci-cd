//This service is with autoscaling policy because of Depends_on
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

  tags           = "${var.tags}"
  propagate_tags = "${var.propagate_tags}"
}

//Scaling of ECS
resource "aws_appautoscaling_target" "ecs_target" {
  count              = "${var.fargate_compatibilitie == "Ec2" ? 1 : 0}"
  max_capacity       = "${var.max_capacity}"
  min_capacity       = "${var.min_capacity}"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.service_ec2[count.index].name}"
  role_arn           = "${var.role_arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = ["aws_ecs_service.service_ec2"]
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  count              = "${var.fargate_compatibilitie == "Ec2" ? 1 : 0}"
  name               = "${var.name}-${var.predefined_metric_type}"
  policy_type        = "${var.policy_type}"
  resource_id        = "${aws_appautoscaling_target.ecs_target[count.index].resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.ecs_target[count.index].scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.ecs_target[count.index].service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "${var.predefined_metric_type}"
    }

    target_value       = "${var.target_value}"
    scale_in_cooldown  = "${var.scale_in_cooldown}"
    scale_out_cooldown = "${var.scale_out_cooldown}"
  }

  depends_on = ["aws_appautoscaling_target.ecs_target", "aws_ecs_service.service_ec2"]
}

//Scaling not yet implemented to Fargate Instances
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

  tags           = "${var.tags}"
  propagate_tags = "${var.propagate_tags}"
}
