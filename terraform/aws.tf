variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.42"
}

provider "aws" {
  region = "us-east-1"
  alias  = "cloudfront_acm"
}
