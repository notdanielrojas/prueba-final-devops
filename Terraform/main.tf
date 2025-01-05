# Módulo VPC
module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
}

# Módulo Subredes
module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

# Módulo Internet Gateway
module "igw" {
  source = "./modules/igw"

  vpc_id = module.vpc.vpc_id
}

# Módulo Tabla de Rutas
module "route" {
  source = "./modules/route"
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  subnet_id = module.subnet.public_subnet_id
}

# Módulo Grupo de Seguridad
module "sg" {
  source = "./modules/sg"

  vpc_id = module.vpc.vpc_id
}

# Módulo EC2
module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  security_group_ids = [module.sg.security_group_id]
  subnet_id = module.subnet.public_subnet_id
  key_name = var.key_name
}

# Módulo Lambda
module "lambda" {
  source            = "./modules/lambda"
  sns_topic_arn     = module.sns.sns_topic_arn
  lambda_name       = var.lambda_name
  lambda_handler    = var.lambda_handler
  lambda_runtime    = var.lambda_runtime
  lambda_role_arn   = module.iam.lambda_role_arn
  lambda_source_path = var.lambda_source_path
  sqs_queue_arn     = module.sqs.sqs_queue_arn
  lambda_batch_size = var.lambda_batch_size
  lambda_trigger_enabled = var.lambda_trigger_enabled
}

# Módulo SNS
module "sns" {
  source     = "./modules/sns"
  topic_name = var.topic_name
  email_address = var.email_address
}

# Módulo SQS
module "sqs" {
  source         = "./modules/sqs"
  sqs_queue_name = "sqs-prueba-final"
  sns_topic_arn  = module.sns.sns_topic_arn
}

# Módulo IAM
module "iam" {
  source          = "./modules/iam"
  lambda_role_name = var.lambda_role_name
  sqs_queue_arn    = module.sqs.sqs_queue_arn
  sns_topic_arn    = module.sns.sns_topic_arn
}