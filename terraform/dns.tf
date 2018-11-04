resource "aws_route53_zone" "this" {
  name    = "frklft.tires."
  comment = "HostedZone created by Route53 Registrar"
}

resource "aws_route53_record" "www_A" {
  name    = "www"
  zone_id = "${aws_route53_zone.this.zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.www.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_AAAA" {
  name    = "www"
  zone_id = "${aws_route53_zone.this.zone_id}"
  type    = "AAAA"

  alias {
    name                   = "${aws_cloudfront_distribution.www.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "naked_A" {
  name    = "frklft.tires"
  zone_id = "${aws_route53_zone.this.zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.naked.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.naked.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "naked_AAAA" {
  name    = "frklft.tires"
  zone_id = "${aws_route53_zone.this.zone_id}"
  type    = "AAAA"

  alias {
    name                   = "${aws_cloudfront_distribution.naked.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.naked.hosted_zone_id}"
    evaluate_target_health = false
  }
}
