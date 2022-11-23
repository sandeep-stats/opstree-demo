locals {
  key_name = "opstree-demo-key-pair"
  az1      = ["ap-south-1a"]
  az2      = ["ap-northeast-1d"]
  env      = "dev"
  common_tags = {
    "Organisation" = "Opstree"
    "Product"      = "Evaluation"
    "Env"          = "Dev"
  }
}
