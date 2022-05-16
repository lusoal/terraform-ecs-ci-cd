output "name" {
  value = aws_codedeploy_app.deployment.name
}

output "deployment_group_arn" {
  value = aws_codedeploy_deployment_group.ecs.arn
}