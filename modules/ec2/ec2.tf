
resource "aws_launch_configuration" "nginx" {
  instance_type               = var.instance_type
  image_id                    = data.aws_ami.opstree_ami.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file("${path.module}/userdata.tpl")

  security_groups = [aws_security_group.this.id]
  tags            = var.tags
}

// Auto scaling group
resource "aws_autoscaling_group" "nginx_asg" {
  availability_zones        = var.availability_zones
  name                      = format("opstree-nginx-asg-%s", var.env)
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  load_balancers = [
    aws_elb.nginx_elb.id
  ]
  termination_policies = ["OldestInstance"]
  launch_configuration = aws_launch_configuration.nginx.name
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

# ASG Scheduler
resource "aws_autoscaling_schedule" "this" {
  scheduled_action_name  = "nginx-scheduler"
  min_size               = -1
  max_size               = -1
  desired_capacity       = 2
  recurrence             = "0 23 * * *" # Increase the desired capacity to 2 every night at 11 PM
  time_zone              = "Asia/Kolkata"
  start_time             = "2022-11-23T18:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
}

# LB
resource "aws_elb" "nginx_elb" {
  name                      = "nginx-elb"
  security_groups           = [aws_security_group.this.id]
  subnets                   = data.aws_subnets.this.ids
  cross_zone_load_balancing = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
  tags = var.tags
}
