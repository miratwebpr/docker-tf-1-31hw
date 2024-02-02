resource "aws_security_group" "ecs_tasks" {
    name = "myapp-ecs-tasks-security_group"
    description = "allow inbound access for all 80 port"
    vpc_id = data.aws_vpc.main.id

    ingress {
        protocol = "tcp"
        from_port = var.app_port
        to_port = var.app_port
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
    version = "2012-10-17"
    statement {
        sid = ""
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = var.ecs_task_execution_role_name
    assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachement" "ecs_task_execution_role" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
