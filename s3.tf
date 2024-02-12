terraform {
  backend "s3" {
    bucket = "bucketshokhrukh"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}