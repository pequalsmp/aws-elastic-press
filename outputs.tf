output "dns_name" {
  description = "IP address of your new blog"
  value       = aws_lb.alb1.dns_name
}
