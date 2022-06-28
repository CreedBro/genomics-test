resource "aws_security_group" "maingrp" {
  name        = "maingrp"
  description = "Restrict all traffice except to my ip"
  vpc_id      = aws_vpc.secondary.id


  ingress {
    description = "All ports from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "All ports from vpc"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "All ports from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  /*egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    
  }*/

  tags = {
    Name = "main security group"
  }

}

data "aws_prefix_list" "private_s3" {
  prefix_list_id = aws_vpc_endpoint.s3.prefix_list_id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  prefix_list_ids   = [aws_vpc_endpoint.s3.prefix_list_id]
  from_port         = 0
  security_group_id = aws_security_group.maingrp.id
}

resource "aws_security_group_rule" "allow_all2" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.maingrp.id
}