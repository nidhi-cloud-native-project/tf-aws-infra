# Creates a public hosted zone for the specified domain
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Creates an A record pointing to the EC2 instance's public IP
resource "aws_route53_record" "app_a_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_instance.app_instance.public_ip]
}