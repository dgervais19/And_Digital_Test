resource "aws_security_group" "alb_sec" {    
  name        = "alb-sg"    
  description = "Security groups for load balance"    
  vpc_id      = aws_vpc.main.id   
    
  ingress {    
    from_port = 80    
    to_port   = 80    
    protocol  = "tcp"    
    cidr_blocks = ["0.0.0.0/0"]  # use my ip
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }


  egress {    
    from_port   = 80    
    to_port     = 80    
    protocol    = "tcp"    
    cidr_blocks = ["0.0.0.0/0"]    
  } 
    
  lifecycle {    
    create_before_destroy = true    
  }    
}  
