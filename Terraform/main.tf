provider "aws" {
  region = "ap-south-1"
}

resource "aws_ecr_repository" "reactjs_ui" {
  name = "reactjs-ui"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_repository" "strapi_api" {
  name = "strapi-api"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecs_cluster" "main" {
  name = "adamecs-fargate-cluster"
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution.json

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "reactjs_ui" {
  family                   = "reactjs-ui-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([
    {
      name      = "reactjs-ui"
      image     = "${aws_ecr_repository.reactjs_ui.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "strapi_api" {
  family                   = "strapi-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([
    {
      name      = "strapi-api"
      image     = "${aws_ecr_repository.strapi_api.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "reactjs_ui" {
  name            = "reactjs-ui-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.reactjs_ui.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-0cd3d771cb3f4d587"]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "strapi_api" {
  name            = "strapi-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.strapi_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-0cd3d771cb3f4d587"]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = "vpc-00897f625567d2980"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_zone" "main" {
  name = "contentecho.in"
}

resource "aws_route53_record" "reactjs_ui" {
  zone_id = "Z06607023RJWXGXD2ZL6M"
  name    = "adamreactjs"
  type    = "A"
  ttl     = "300"
  records = ["13.126.205.90"]
}

resource "aws_route53_record" "strapi_api" {
  zone_id = "Z06607023RJWXGXD2ZL6M"
  name    = "adam-api"
  type    = "A"
  ttl     = "300"
  records = ["13.126.205.90"]
}
