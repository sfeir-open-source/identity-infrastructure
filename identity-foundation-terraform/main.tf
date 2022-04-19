module "identity_foundation_factory" {
  source         = "./modules/factory"
  git_tag_name   = var.git_tag_name
  google_project = var.google_project
  google_region  = var.google_region
}

module "identity_foundation_infrastructure" {
  source                                           = "./modules/infrastructure"
  google_project                                   = var.google_project
  google_region                                    = var.google_region
  oathkeeper_container_image_name                  = module.identity_foundation_factory.oathkeeper_container_image_name
  identity_foundation_account_container_image_name = module.identity_foundation_factory.identity_foundation_account_container_image_name
  identity_foundation_app_container_image_name     = module.identity_foundation_factory.identity_foundation_app_container_image_name
  oathkeeper_proxy_public_url                      = var.oathkeeper_proxy_public_url
  identity_foundation_account_public_url           = var.identity_foundation_account_public_url
  identity_foundation_app_public_url               = var.identity_foundation_app_public_url
}
