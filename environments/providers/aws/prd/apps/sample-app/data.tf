data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}


data "aws_ecs_task_definition" "sample-app" {
  task_definition = module.task_definition.family_ec2
}