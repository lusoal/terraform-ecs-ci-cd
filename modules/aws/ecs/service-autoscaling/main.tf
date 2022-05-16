resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = "${var.max_capacity}"
  min_capacity       = "${var.min_capacity}"
  resource_id        = "service/${var.cluster_name}/${var.app_name}"
  role_arn           = "${var.role_arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "${var.name}-${var.predefined_metric_type}"
  policy_type        = "${var.policy_type}"
  resource_id        = "service/${var.cluster_name}/${var.app_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "${var.predefined_metric_type}"
    }

    target_value       = "${var.target_value}"
    scale_in_cooldown  = "${var.scale_in_cooldown}"
    scale_out_cooldown = "${var.scale_out_cooldown}"
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}
