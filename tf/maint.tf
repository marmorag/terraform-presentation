provider "netlify" {
  token = var.netlify_token
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

resource "github_repository_deploy_key" "key" {
  title      = "Netlify"
  repository = "terraform-presentation"
  key        = netlify_deploy_key.key.public_key
  read_only  = false
}

resource "netlify_deploy_key" "key" {}

resource "netlify_site" "tf-presentation" {
  name = "tf-presentation"

  repo {
    repo_branch   = "master"
    command       = "yarn build"
    deploy_key_id = netlify_deploy_key.key.id
    dir           = "public"
    provider      = "github"
    repo_path     = "marmorag/terraform-presentation"
  }
}

resource "github_repository_webhook" "webhook" {
  repository = "terraform-presentation"
  events     = ["delete", "push", "pull_request"]

  configuration {
    content_type = "json"
    url          = "https://api.netlify.com/hooks/github"
  }

  depends_on = [netlify_site.tf-presentation]
}