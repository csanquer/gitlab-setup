resource "aws_elasticache_subnet_group" "gitlab_cache" {
    name = "gitlab-cache-subnet"
    subnet_ids = ["${var.private_subnet_ids["private1"]}", "${var.private_subnet_ids["private2"]}"]
}

resource "aws_elasticache_cluster" "gitlab_cache" {
    cluster_id = "gitlab-cache"
    engine = "redis"
    engine_version = "3.2.4"
    node_type = "cache.t2.small"
    port = 6379
    num_cache_nodes = 1
    parameter_group_name = "default.redis3.2"
    subnet_group_name = "${aws_elasticache_subnet_group.gitlab_cache.name}"
    security_group_ids = ["${aws_security_group.gitlab_cache.id}"]
}

resource "aws_security_group" "gitlab_cache" {
  name        = "gitlab-cache"
  description = "Allow traffic to gitlab cache"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    security_groups = ["${aws_security_group.gitlab.id}"]
  }
}
