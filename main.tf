

provider "aws" {
  region = "eu-central-1"
}

#using a remote backend so that other team members can also maintain it
terraform {
  backend "s3" {
    bucket = "ankurbhatiamunich"
    key    = "alasco-coding-test"
    region = "eu-central-1"
  }
}


