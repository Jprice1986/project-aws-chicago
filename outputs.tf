output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "app_subnet_ids" {
  value = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id
  ]
}

output "db_subnet_ids" {
  value = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "app_security_group_id" {
  value = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}
output "s3_bucket_name" {
value = aws_s3_bucket.app_bucket.bucket
}

output "dynamodb_table_name" {
value = aws_dynamodb_table.app_table.name
}

output "sns_topic_arn" {
value = aws_sns_topic.alerts.arn
}
