resource "aws_ecs_cluster" "main" {
    name = "myapp-cluster"
}

data "template_file" "myapp" {
    template = file("./templates/ecs/myapp.json.tpl")

    vars = {
        app_image = var.app_image
        app_port = var.app_port
        fargate_cpu = var.fargate_cpu
        fargate_memory = var.fargate_memory
        aws_region = var.aws_region
    }
}

resource "aws_ecs_task_definition" "app" {
    family = "myapp_task"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = var.fargate_cpu
    memory = var.fargate_memory
    container_definitions = data.template_file.myapp.rendered
}

resource "aws_ecs_service" "main" {
    name = "myapp-service"
    cluster = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count = var.app_count
    launch_type = "FARGATE"
    enable_ecs_managed_tags = true

    network_configuration {
        security_groups = [aws_security_group.ecs_tasks.id]
        subnets = [for s in data.aws_subnet.main : s.id]
        assign_public_ip = true
    }
    depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

# data "aws_network_interface" "interface_tags" {
#     filter {
#         name   = "tag:aws:ecs:${aws_ecs_service.main.name}"
#         values = [aws_ecs_service.main.name]
#     }
#     depends_on = [aws_ecs_service.main]
# }

