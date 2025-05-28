output "alb_dns_name" {
  description = "Access NGINX here"
  value       = aws_lb.lb.dns_name
}