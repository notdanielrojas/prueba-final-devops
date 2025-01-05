output "vpc_id" {
  value = module.vpc.vpc_id
  description = "ID de la VPC creada"
}

output "public_subnet_id" {
  value = module.subnet.public_subnet_id
  description = "ID de la subred pública"
}

output "ec2_public_ip" {
  value = module.ec2.instance_public_ip
  description = "IP pública de la instancia EC2"
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}