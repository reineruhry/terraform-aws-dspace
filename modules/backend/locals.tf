locals {
  assetstore_volume        = "${local.name}-assetstore"
  assign_public_ip         = var.assign_public_ip
  backend_url              = var.backend_url
  capacity_provider        = var.capacity_provider
  cli_cpu                  = var.cli_cpu
  cli_memory               = var.cli_memory
  cluster_id               = var.cluster_id
  cpu                      = var.cpu
  custom_env_cfg           = var.custom_env_cfg
  custom_secrets_cfg       = var.custom_secrets_cfg
  db_host                  = var.db_host
  db_name                  = var.db_name
  db_password_arn          = var.db_password_arn
  db_username_arn          = var.db_username_arn
  dspace_name              = var.dspace_name
  dspace_xmx               = var.dspace_xmx
  efs_id                   = var.efs_id
  frontend_url             = var.frontend_url
  host                     = var.host
  img                      = var.img
  instances                = var.instances
  listener_arn             = var.listener_arn
  listener_priority        = var.listener_priority
  log4j2_url               = var.log4j2_url
  memory                   = var.memory
  name                     = var.name
  namespace                = var.namespace
  network_mode             = var.network_mode
  port                     = var.port
  requires_compatibilities = var.requires_compatibilities
  security_group_id        = var.security_group_id
  solr_url                 = var.solr_url
  subnets                  = var.subnets
  tags                     = var.tags
  target_type              = var.target_type
  tasks                    = var.tasks
  timezone                 = var.timezone
  vpc_id                   = var.vpc_id

  task_config = {
    assetstore         = local.assetstore_volume
    backend_url        = local.backend_url
    custom_env_cfg     = local.custom_env_cfg
    custom_secrets_cfg = local.custom_secrets_cfg
    db_host            = local.db_host
    db_name            = local.db_name
    db_password_arn    = local.db_password_arn
    db_url             = "jdbc:postgresql://${local.db_host}:5432/${local.db_name}"
    db_username_arn    = local.db_username_arn
    dspace_name        = local.dspace_name
    dspace_dir         = "/dspace" # TODO: var?
    frontend_url       = local.frontend_url
    host               = local.host
    img                = local.img
    log_group          = aws_cloudwatch_log_group.this.name
    log4j2_url         = local.log4j2_url
    memory             = local.dspace_xmx
    name               = local.name
    network_mode       = local.network_mode
    port               = local.port
    region             = data.aws_region.current.name
    solr_url           = local.solr_url
    timezone           = local.timezone
  }
}
