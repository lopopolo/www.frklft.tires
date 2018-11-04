terraform {
  required_version = ">= 0.11.10"

  backend "s3" {
    bucket         = "hyperbola-terraform-state"
    region         = "us-east-1"
    key            = "terraform/frklft-prod-northwest/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform_statelock"
  }
}

resource "aws_s3_bucket" "www" {
  bucket = "www.frklft.tires"
  acl    = "public-read"

  website {
    index_document = "index.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "HttpErrorCodeReturnedEquals": "404"
    },
    "Redirect": {
        "HttpRedirectCode": "302",
        "Protocol": "https",
        "HostName": "www.frklft.tires",
        "ReplaceKeyWith": ""
    }
}]
EOF
  }
}

data "aws_acm_certificate" "www" {
  provider = "aws.cloudfront_acm"
  domain   = "www.frklft.tires"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "www" {
  origin {
    domain_name = "${aws_s3_bucket.www.website_endpoint}"
    origin_id   = "s3-website"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront for www.frklft.tires"

  aliases = ["www.frklft.tires"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-website"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Environment = "frklft-prod"
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.www.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

resource "aws_s3_bucket" "naked" {
  bucket = "frklft.tires"
  acl    = "public-read"

  website {
    redirect_all_requests_to = "https://www.frklft.tires"
  }
}

data "aws_acm_certificate" "naked" {
  provider = "aws.cloudfront_acm"
  domain   = "www.frklft.tires"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "naked" {
  origin {
    domain_name = "${aws_s3_bucket.naked.website_endpoint}"
    origin_id   = "s3-website"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront for frklft.tires"

  aliases = ["frklft.tires"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-website"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Environment = "frklft-prod"
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.naked.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}
