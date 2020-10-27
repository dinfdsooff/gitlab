terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.1.0"
    }
  }
}

# Configure the GitLab Provider
provider "gitlab" {
    token = "xxxx"
    base_url = "http://localhost:8080/api/v4/"
    insecure = true
}

locals {
  input = yamldecode(file("input.yaml"))
}


locals {
  x = flatten([for grp_key, group in local.input.group: [for project in group.projects: { group_name=group.name, project_name=project} ]])
  
  #  Output of local.x
  #   [
  #   {
  #     "group_name" = "group1"
  #     "project_name" = "project1"
  #   },
  #   {
  #     "group_name" = "group1"
  #     "project_name" = "project3"
  #   },
  # ]
}


resource "gitlab_project" "example" {
  count       = length(local.x)
  name        = local.x[count.index].project_name
  namespace_id   = module.group.output
  #namespace_id   = < get the id of the group resource you are going to create next, pass as input "local.x[count.index].project_name" to module "./create_group" >
}

module "group" {
  source = "./group"
}