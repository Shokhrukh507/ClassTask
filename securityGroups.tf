# ALB sec group
resource "aws_security_group" "ALB" {
  name = "ALB security group"
  description = "To be used by ALB in the project"
  vpc_id = aws_vpc.vpcForProject.id

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
# Traffic to ECS cluster should only come from ALB
resource "aws_security_group" "ecs_tasks" {
  name = "ecs-task-sec-group"
  description = "allow inbound access from the ALB only"
  vpc_id = aws_vpc.vpcForProject.id

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