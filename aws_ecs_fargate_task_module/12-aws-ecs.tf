# resource "aws_ecs_cluster" "workers" {
#   tags = {
#     "cluster tag1" = "tag value 1"
#     "clustertag2" = "tag value 1"
#   }
#   name = "${var.operation_name}"
#   #name = "hfs-nightly-jobs-tf"
# }