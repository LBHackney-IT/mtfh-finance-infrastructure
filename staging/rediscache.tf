resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id           = "redis-${var.environment_name}"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
}