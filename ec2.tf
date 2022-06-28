#Instance creation
resource "aws_instance" "main" {
  ami                    = var.ami-id
  instance_type          = var.instance_type
  user_data              = file("genomics-docker-flask-userdata.sh")
  iam_instance_profile   = aws_iam_instance_profile.access_s3.name
  key_name               = aws_key_pair.gen_key.key_name
  vpc_security_group_ids = ["${aws_security_group.maingrp.id}"]
  subnet_id              = aws_subnet.secondary.id
  associate_public_ip_address = true


  tags = {
    Name = "HelloWorld"
  }
}

#Change this public key to yours
resource "aws_key_pair" "gen_key" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZfO5M4ErJ/stcARHVDrVJYM9AVNiHvvnt1hIU5NUPqelA81LzuXqeSZMxma8PIeNHQzslCs8mE9sYCEFS8MT94jhT1Yi3W3Wboil5GrLEkd1ZiMe6Bm9OztkjknqEOQyza2y4n16XJjFfooFmGMPJLdi0V2PwVjAVRs7Yx2xcJkx26kogSfg7VkyM/Qz4ZKo3UdwocU8lbUFxGpgGU0rYUgqFc1XAWfiZ9Le0hMZqnAeqve9LWy6kjSm82D4KSGojuPK6gfStuMdT59XZTk/zM/+7NXh+cbvlbeceutYUm6Kl3Hc1dy5VZv1O3WijfDnHy2UNsAUafW8OgvTsDkruEgCHob2Hnk27s50eL/hHr9m/ztXbBhc6aGgk0uwKdheR3F7h5mS1+8No6P0nNszYtvHwrhMnKD22Q4DeV1faGcsRicA25fqAfnE8fTOtgfP+I8rq+xD8W1gjB1ITcUAp3l8niIdrfMHCsNsiVMttg7CX1Xjo0P5v+8fCkVKb7YE= TechBro@DESKTOP-ACJNIOU"
}

#Creation of IAM instance role/policy/profile to 
#facilitate private/secure connectivity with S3 bucket
resource "aws_iam_role" "access_s3" {
  name = "access_s3"


  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  
  })

  tags = {
    tag-key = "EC2-to-S3-Access"
  }
}


resource "aws_iam_instance_profile" "access_s3" {
  name = "s3_bucket_access"
  role = aws_iam_role.access_s3.name
}



resource "aws_iam_role_policy" "s3_fullaccess" {
  name = "s3_fullaccess"
  role = aws_iam_role.access_s3.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
       "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
      },
    ]
  })
}


