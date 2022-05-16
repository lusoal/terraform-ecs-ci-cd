# TF script to provision the CodePipeline
module "codebuildproject" {
  source                  = "../../../../../../modules/aws/codebuild"
  private_subnet_list     = tolist(["${module.environment.subnet_private_a}", "${module.environment.subnet_private_b}", "${module.environment.subnet_private_c}"])
  private_subnet1         = module.environment.subnet_private_a
  private_subnet2         = module.environment.subnet_private_b
  codebuild_project_name  = var.app_name
  vpc_id                  = module.environment.vpc_id
  security_group_ids_list = [module.alb_sg.security_group_id]
  tags = {
    Environment = "${var.environment}"
  }
}

module "codedeployapp" {
  source            = "../../../../../../modules/aws/codedeploy"
  app_name          = var.app_name
  ecs_service_name  = var.app_name
  ecs_cluster_name  = var.cluster_name
  main_listener     = module.loadbalancer_lister_http.arn_http
  main_target_group = "ecs-${var.app_name}"
  test_target_group = "ecs-${var.app_name}-test"
  test_listener     = module.loadbalancer_lister_http_test.arn_http
}

module "codepipelineproject" {
  source        = "../../../../../../modules/aws/codepipeline"
  pipeline_name = var.app_name
  repo_name     = var.repo_name

  codebuild_project = var.app_name # CodeBuild Project Name
  app_name          = var.app_name
  deployment_group_name = "deployment-group-${var.app_name}"
}