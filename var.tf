variable "aws_region" {
    description = "The AWS region that we are gonna use"
    default = "us-east-1"
}

variable "ecs_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myECSTaskExecutionRole1"
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = 1
}

variable "app_image" {
    description = "Docker image to run on an ECS cluster"
    default = "mirow228/apache_image:latest"
}

variable "app_port" {
    description = "Port that is gonna be exposed by docker image to redirect traffic to "
    default = 80
}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 1
}

variable "health_check_path" {
    default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}   

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}









