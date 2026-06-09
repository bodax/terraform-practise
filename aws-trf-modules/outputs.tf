output "lb_dns_name" {
  value = module.application.lb_dns_name
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}
