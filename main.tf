variable "git_url" {
  type        = string
  description = "Git URL for the repository"
}

variable "git_project_name" {
  type        = string
  description = "Git project name"
  default = "app"
}

variable "key_pub_path" {
  type        = string
  description = "Path to the public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "key_private_path" {
  type        = string
  description = "Path to the private key"
  default     = "~/.ssh/id_rsa"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH inbound traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http-access" {
  name        = "http-access"
  description = "Allow HTTP inbound traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "https-access" {
  name        = "https-access"
  description = "Allow HTTPS inbound traffic"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform-key"
  public_key = file("./tutu.pub")

}

resource "aws_instance" "terraform_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.terraform_key_pair.key_name

  security_groups = [
    aws_security_group.ssh-access.name,
    aws_security_group.http-access.name,
    aws_security_group.https-access.name
  ]

  tags = {
    Name = "terraform_figlet"
  }
}


resource "null_resource" "install_figlet_on_instance" {
  connection {
    type        = "ssh"
    host        = aws_instance.terraform_instance.public_ip
    user        = "ubuntu"
    private_key = file("tutu")
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "./script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/script.sh ./",
      "sudo chmod 777 ./script.sh",
      "sudo chmod +x ./script.sh",
      "./script.sh ${var.git_url} ${var.git_project_name}",
    ]
  }

  depends_on = [aws_instance.terraform_instance]
}
