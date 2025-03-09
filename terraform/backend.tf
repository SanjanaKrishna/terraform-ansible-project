terraform {
  backend "s3" {
    bucket         = "terraform-jenkins-sanjana"
    key            = "remote.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
  }
}
