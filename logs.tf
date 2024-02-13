resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/myapp"
  retention_in_days = 30

  tags = {
    Name = "cb_log_group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name = "my-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}