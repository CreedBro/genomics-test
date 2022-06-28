# outputs.tf
output "user_arn" {
    value = aws_iam_user.genomics_users.*.arn

}

output "ec2_public_ip" {
  value = ["${aws_instance.main.public_ip}"]
}