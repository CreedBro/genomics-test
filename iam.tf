#Creation of users 
resource "aws_iam_user" "genomics_users" {
    count = "${length(var.username)}"
    name = "${element(var.username,count.index)}"
    path = "/system/"

}

resource "aws_iam_access_key" "genomics_key" {
    count = "${length(var.username)}"
    user = "${element(var.username,count.index)}"
    depends_on = [
      aws_iam_user.genomics_users
    ]
}

#Creation of user groups to which policies are then applied
resource "aws_iam_group" "devgrp" {
  name = "dev"
  path = "/system/"
}

resource "aws_iam_group" "testgrp" {
  name = "test"
  path = "/system/"
}

resource "aws_iam_group_membership" "dev" {
  name = "tf-dev-group-membership"
  
  users = [
    "${element(var.username,0)}"
    
  ]

  group = aws_iam_group.devgrp.name
}

resource "aws_iam_group_membership" "test" {
  name = "tf-testing-group-membership"
  
  users = [
   "${element(var.username,1)}"
    
  ]

  group = aws_iam_group.testgrp.name
}

resource "aws_iam_group_policy" "dev_policy" {
  name  = "my_dev_policy"
  group = aws_iam_group.devgrp.name

  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
       "Sid": "Stmt1656341706941",
      "Action": [
        "s3:GetObject",
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "Stmt1656342461989",
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
      },
    ]
  })
}

resource "aws_iam_group_policy" "test_policy" {
  name  = "my_test_policy"
  group = aws_iam_group.testgrp.name

  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
       "Sid": "Stmt1656341706941",
      "Action": [
        "s3:GetObject",
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "Stmt1656342748884",
      "Action": "ec2:*",
      "Effect": "Deny",
      "Resource": "*"
      },
    ]
  })
}



