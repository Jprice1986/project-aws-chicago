output "public_server_public_ip" {
value = aws_instance.public_server.public_ip
}

output "public_server_private_ip" {
value = aws_instance.public_server.private_ip
}

output "private_server_private_ip" {
value = aws_instance.private_server.private_ip
}

