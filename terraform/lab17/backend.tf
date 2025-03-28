terraform {
  backend "s3" {
    bucket = "lab17-tf-state-storage"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
