#
module "secret" {
  source = "./module_secret"
  #
  for_each = var.secret_manager_defaults
  #
  bucket               = lookup(each.value, "bucket", null)
  current_transfer_id  = local.current_transfer_id
  role                 = lookup(each.value, "role", null)
  sftp_user            = lookup(each.value, "sftp_user", null)
  HomeDirectoryDetails = lookup(each.value, "HomeDirectoryDetails", null)
  #
  tags = local.tags
}