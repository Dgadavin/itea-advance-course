resource "aws_acm_certificate" "project_cert" {
  domain_name       = var.certificate_domain_name
  validation_method = "DNS"

  subject_alternative_names = var.certificate_alternative_name

  tags = {
    Name        = "${local.service_naming_convention}-acm"
    Application = var.appname
    Role        = "ACM"
    Environment = var.environment
    Terraform   = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.project_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.domain_zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.project_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns_validation : record.fqdn]
}
