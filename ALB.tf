resource "aws_alb" "projectALB" {
    name = "Project ALB"
    subnets = aws_subnet.public.*.id
    security_groups = [aws_security_group.ALB.id]  
}
resource "aws_alb_target_group" "projectTG" {
    name = "projectTG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpcForProject.id
    target_type = "ip"
    health_check {
      healthy_threshold = "3"
      interval = "30"
      protocol = "HTTP"
      matcher = "200"
      timeout = "3"
      path = var.health_check_path
      unhealthy_threshold = "2"
    }
}

resource "aws_alb_listener" "projectListener" {
    load_balancer_arn = aws_alb.projectALB.arn
    port = var.app_port
    protocol = "HTTP" 

    default_action {
     target_group_arn = aws_alb_target_group.projectTG.arn
     type = "forward" 
    } 
}