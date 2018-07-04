terraform {
  backend "s3" {
    bucket = "soundplace-tfstate"
    region = "us-east-1"
    key    = "terraform.tfstate"
  }
}
