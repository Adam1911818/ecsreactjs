output "ecr_reactjs_ui_repository_url" {
  description = "URL of the ECR repository for the ReactJS UI"
  value       = aws_ecr_repository.reactjs_ui.repository_url
}

output "ecr_strapi_api_repository_url" {
  description = "URL of the ECR repository for the Strapi API"
  value       = aws_ecr_repository.strapi_api.repository_url
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_reactjs_ui_service_name" {
  description = "Name of the ECS service for the ReactJS UI"
  value       = aws_ecs_service.reactjs_ui.name
}

output "ecs_strapi_api_service_name" {
  description = "Name of the ECS service for the Strapi API"
  value       = aws_ecs_service.strapi_api.name
}

output "reactjs_ui_dns_name" {
  description = "DNS name for the ReactJS UI"
  value       = aws_route53_record.reactjs_ui.fqdn
}

output "strapi_api_dns_name" {
  description = "DNS name for the Strapi API"
  value       = aws_route53_record.strapi_api.fqdn
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "reactjs_ui_task_definition_arn" {
  description = "ARN of the task definition for ReactJS UI"
  value       = aws_ecs_task_definition.reactjs_ui.arn
}

output "strapi_api_task_definition_arn" {
  description = "ARN of the task definition for Strapi API"
  value       = aws_ecs_task_definition.strapi_api.arn
}

output "route53_zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}
