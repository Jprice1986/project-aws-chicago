resource "aws_sns_topic" "alerts" {
name = "cloudops-alerts"
}

resource "aws_cloudwatch_metric_alarm" "public_server_cpu_high" {
alarm_name = "public-server-cpu-high"
comparison_operator = "GreaterThanThreshold"
evaluation_periods = 1
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = 300
statistic = "Average"
threshold = 70
alarm_description = "Alarm if public server CPU goes above 70 percent"
alarm_actions = [aws_sns_topic.alerts.arn]

dimensions = {
InstanceId = aws_instance.public_server.id
}
}

resource "aws_cloudwatch_metric_alarm" "private_server_cpu_high" {
alarm_name = "private-server-cpu-high"
comparison_operator = "GreaterThanThreshold"
evaluation_periods = 1
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = 300
statistic = "Average"
threshold = 70
alarm_description = "Alarm if private server CPU goes above 70 percent"
alarm_actions = [aws_sns_topic.alerts.arn]

dimensions = {
InstanceId = aws_instance.private_server.id
}
}
