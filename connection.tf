provider "google" {
  credentials = "${file("../account.json")}"
  project     = "tft-first-project"
  region      = "us-west1"
}

provider "aws" {
  region = "${var.aws_regions["or"]}"
}
