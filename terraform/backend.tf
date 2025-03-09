terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-sanjana"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
