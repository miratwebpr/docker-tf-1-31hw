resource "aws_cloudwatch_log_group" "myapp_log_group" {
    name = "/ecs/myapp"
    retention_in_days = 30

    tags = {
        Name = "cb-log-group"
    }
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
    name = "my-log-stream"
    log_group_name = aws_cloudwatch_log_group.myapp_log_group.name
}