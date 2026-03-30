data "aws_ami" "amazon_linux" {
most_recent = true

owners = ["137112412989"]

filter {
name = "name"
values = ["al2023-ami-*-x86_64"]
}
}

resource "aws_instance" "public_server" {
ami = data.aws_ami.amazon_linux.id
instance_type = "t2.micro"
subnet_id = aws_subnet.public_a.id
vpc_security_group_ids = [aws_security_group.app_sg.id]
associate_public_ip_address = true

tags = {
Name = "public-server"
}
}

resource "aws_instance" "private_server" {
ami = data.aws_ami.amazon_linux.id
instance_type = "t2.micro"
subnet_id = aws_subnet.app_a.id
vpc_security_group_ids = [aws_security_group.app_sg.id]

tags = {
Name = "private-server"
}
}

