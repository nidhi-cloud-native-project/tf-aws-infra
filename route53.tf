resource "aws_route53_record" "webapp_dns" {
  zone_id = var.route53_zone_id       # Replace this via variable
  name    = "demo.${var.root_domain}" # E.g., demo.csye6225.com
  type    = "A"

  alias {
    name                   = aws_lb.webapp_alb.dns_name
    zone_id                = aws_lb.webapp_alb.zone_id
    evaluate_target_health = true
  }
}