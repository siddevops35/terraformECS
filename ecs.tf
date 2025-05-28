resource "aws_ecs_cluster" "main" {
  name = "nginx-cluster"
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = var.nginx_image
      portMappings = [{
        containerPort = 80
        protocol      = "tcp"
      }]
    }
  ])
}

resource "aws_ecs_service" "nginx" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.nginx.arn
    container_name   = "nginx"
    container_port   = 80
  }
  depends_on = [aws_lb_listener.http]
}
