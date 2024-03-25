resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "housing-finance-redis-subnet-${var.environment_name}"
  subnet_ids = ["subnet-0beb266003a56ca82","subnet-06a697d86a9b6ed01"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_replication_group" "redis_cache" {
  automatic_failover_enabled    = true
  replication_group_id          = "redis-finance-${var.environment_name}-1"
  description = "mtfh finance redis group"
  node_type             = "cache.t3.small"
  num_cache_clusters    = 2
  parameter_group_name  = "default.redis5.0"
  engine_version        = "5.0.6"
  port                  = 6379
  security_group_ids    = [aws_security_group.mtfh_finance_security_group.id]
  subnet_group_name     = "${aws_elasticache_subnet_group.redis_subnets.name}"
}

resource "aws_elasticache_cluster" "replica" {
  count = 1

  cluster_id           =  "redis-finance-${var.environment_name}-${count.index}"
  replication_group_id = aws_elasticache_replication_group.redis_cache.id
}