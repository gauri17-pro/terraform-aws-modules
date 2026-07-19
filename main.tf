data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_security_group" "ec2_sg" {
    name        = "ec2-instance-sg"
    description = "Security group for EC2 instance"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ec2-sg"
    }
}

resource "aws_instance" "ec2_instance" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.instance_type
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "my-ec2-instance"
    }
}


