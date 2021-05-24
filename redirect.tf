resource "aws_launch_configuration" "as_conf" {
  name          = "launch_config"
  image_id      = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.alb_sec.id}"]
  user_data = <<EOF
  #!/bin/bash
  sudo apt install nginx -y
  sudo systemctl enable nginx
  sudo cd /var/www/html
  sudo mv index.html index.html.bk
  sudo touch index.html
  cat <<£ > index.html
  <!DOCTYPE html>
<html>
<body>

<h1>My website is live on NGINX!</h1>

<p>Hello World!</p>

</body>
</html>
£
sudo systemctl restart nginx
EOF
}

resource "aws_autoscaling_group" "scalegroup" {
  name                  = "webnodes"
  launch_configuration  = aws_launch_configuration.as_conf.name
  # min_size of 2 ticks off the requirement of having at least two instances
  min_size              = 2
  wait_for_elb_capacity = 2
  max_size              = 4
  min_elb_capacity      = 2
  health_check_type     = "ELB"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  # target_group_arns = [aws_alb_target_group.http.arn]

  lifecycle {
    create_before_destroy = true
  }

}


# ALB  (Automatic Load Balance)
# resource "aws_alb" "web" {
#   name               = "web-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]

#   enable_deletion_protection = false

# }

# resource "aws_alb_listener" "https_listener" {
#   load_balancer_arn = aws_alb.web.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.http.arn
#   }
# }


resource "aws_alb_target_group" "http" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

