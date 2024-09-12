#
resource "aws_eip" "sftp" {
  domain = "vpc"
  #
  tags = merge(
    local.tags,
    {
      "Name" = var.transfer_defaults.name,
    }
  )
}