provider "aws" {
  profile = "personal"
  region  = "ap-south-1"
}

provider "aws" {
  profile = "personal"
  alias   = "tokyo"
  region  = "ap-northeast-1"
}

module "opstree_nginx" {
  source             = "../../modules/ec2"
  key_name           = local.key_name
  availability_zones = local.az1
  env                = local.env
  tags               = local.common_tags
}

module "opstree_nginx_tokyo" {
  source = "../../modules/ec2"
  providers = {
    aws = aws.tokyo
  }
  key_name           = local.key_name
  availability_zones = local.az2
  env                = local.env
  tags               = local.common_tags
}
