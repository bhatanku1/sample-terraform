resource "aws_ecs_cluster" "alasco" {
  name = "alasco-dev-cluster"
}

resource "aws_ecs_task_definition" "alasco_code_test" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "alasco_code_test-container"
    image     = "ghost"
    essential = true
    logConfiguration = {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : "alasco",
        "awslogs-region" : "eu-central-1",
        "awslogs-stream-prefix" : "coding-test"
      }
    },
    portMappings = [{
      protocol      = "tcp"
      containerPort = 2368
      hostPort      = 2368
    }]
  }])
}

resource "aws_cloudwatch_log_group" "alasco" {
  name = "alasco"

}


resource "aws_ecs_service" "fargate_service" {

  name            = "alasco_coding_test"
  cluster         = aws_ecs_cluster.alasco.id
  task_definition = aws_ecs_task_definition.alasco_code_test.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.alasco.id]
    security_groups  = [aws_security_group.alasco_allow_ghost.id]
    assign_public_ip = true
  }

}