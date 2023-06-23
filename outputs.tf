output "dns_name" {
  description = "FQDN of your new blog"
  value       = aws_lb.alb1.dns_name
}
