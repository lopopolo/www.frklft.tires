variable "contact_email" {}
variable "recaptcha_secret_key" {}

data "template_file" "contact_cloudformation_yaml" {
  template = "$${before}$${lambda_code}$${after}"

  vars {
    before = "${
      element(
        split(
          "lambda-code-42B3B8CA-0C02-477E-93A2-5C33D2E88383",
          file("${path.module}/contact-form-cloudformation-stack.yml")
        ),
      0)}"

    lambda_code = "${
      indent(
        10,
        "${file("${path.root}/../src/index.js")}"
      )}"

    after = "${
      element(
        split(
          "lambda-code-42B3B8CA-0C02-477E-93A2-5C33D2E88383",
          file("${path.module}/contact-form-cloudformation-stack.yml")
        ),
      1)}"
  }
}

resource "aws_cloudformation_stack" "contact" {
  name         = "FRKLFT-Contact-Us"
  capabilities = ["CAPABILITY_IAM"]

  parameters {
    ToEmailAddress  = "${var.contact_email}"
    ReCaptchaSecret = "${var.recaptcha_secret_key}"
  }

  template_body = "${data.template_file.contact_cloudformation_yaml.rendered}"
}

output "contact_api_url" {
  value = "${aws_cloudformation_stack.contact.outputs["ApiUrl"]}"
}
