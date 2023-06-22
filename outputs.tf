output "dns_name" {
  description = "Public IP for the IGW"
  value       = aws_lb.alb1.dns_name
}
