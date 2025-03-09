terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-sanjana"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
  }
}
