locals {
  task_config = {
    email        = var.email
    enabled      = var.enabled ? "true" : "false"
    hostname     = var.hostname
    img          = var.img
    lb_name      = var.lb_name
    port         = var.port
    log_group    = aws_cloudwatch_log_group.this.name
    network_mode = var.network_mode
    region       = data.aws_region.current.name
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.this.arn
  task_role_arn            = aws_iam_role.this.arn

  container_definitions = templatefile("${path.module}/task-definition/certbot.json.tpl", local.task_config)
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.instances

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  load_balancer {
    container_name   = "certbot"
    container_port   = var.port
    target_group_arn = aws_lb_target_group.this.arn
  }

  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? ["true"] : []
    content {
      assign_public_ip = var.assign_public_ip
      security_groups  = [var.security_group_id]
      subnets          = var.subnets
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${var.name}"
  retention_in_days = 7
}
