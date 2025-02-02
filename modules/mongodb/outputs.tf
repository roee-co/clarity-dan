output "cluster_id" {
  value = mongodbatlas_cluster.this.id
}

output "connection_string" {
  value = mongodbatlas_cluster.this.connection_strings[0].standard_srv
}
