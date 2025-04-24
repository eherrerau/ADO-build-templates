locals {
  common_tags = {
    CreatedBy = var.CreatedBy
    # CreatedDate      = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    department       = var.department
    environment      = var.environment
    primaryOwner     = var.primaryOwner
    secondaryOwner   = var.secondaryOwner
    LastDateDeployed = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
  }
}