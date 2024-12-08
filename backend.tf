terraform {
  backend "s3" {
    bucket         = "eks-project-bucket"
    dynamodb_table = "eks_state_locking"
    key            = "eks_project.tfstate"
    region         =  "ap-south-1"
    encrypt        = true

  }
}
