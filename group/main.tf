
# Add a group owned by the user
resource "gitlab_group" "example" {
  name        = "<input>"
  path        = "<input>"
}


output "output" {
  value       = gitlab_group.example.id
  description = "ID"
}
