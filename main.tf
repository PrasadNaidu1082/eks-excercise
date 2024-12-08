resource "aws_security_group" "ec2" {
    name        = "Sandbox SG"
    description = "Sandbox EC2 security group"
    vpc_id      = var.vpc_id

    ingress {
    description      = "allows ssh access to Ec2 Sandbox"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_ssh"
  }
}

resource "aws_instance" "Ec2_sandbox" {
      ami                    = var.ami
      instance_type          = var.instance_type
      count                  = 1
      key_name               = aws_key_pair.schluessel.id
      vpc_security_group_ids = [aws_security_group.ec2.id]
      user_data = <<-EOF

         #!/bin/bash
         sudo su
         hostnamectl set-hostname Ec2_sandbox
         cd /tmp/
         curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
         unzip awscliv2.zip
         ./aws/install
         curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
         curl -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl.sha256
         chmod +x kubectl
         mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
         kubectl version --short --client
         yum install -y yum-utils
         yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
         yum -y install terraform
         yum install -y git
         cd /root/
         git clone https://github.com/Prasad1082/eks-excercise.git


      EOF

      tags = {
      Name = "Ec2_sandbox"
      }
}



resource "aws_s3_bucket" "eks-bucket" {
   bucket = "eks-project-bucket"

   tags = {
     Name   = "eks_project_bucket"
     Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "eks-s3-acl" {
   bucket = aws_s3_bucket.eks-bucket.id
   acl    = "private"
}


resource "aws_dynamodb_table"  "eks_table" {
   name  = "eks_state_locking"
   read_capacity = 20
   write_capacity = 20
   hash_key     = "LockID"

   attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_key_pair" "schluessel" {
        public_key = file("/root/.ssh/aws_key_pair/mein-schluesselpub")
}



