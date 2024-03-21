resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "housing-finance-redis-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0743d86e9b362fa38","subnet-0ea0020a44b98a2ca"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id           = "redis-${var.environment_name}"
  engine               = "redis"
  node_type            = "cache.t3.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  security_group_ids      = [aws_security_group.mtfh_finance_security_group.id]
  subnet_group_name        = "${aws_elasticache_subnet_group.redis_subnets.name}"
}