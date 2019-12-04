provider "netlify" {
  token = var.netlify_token
}

resource "netlify_deploy_key" "key" {}

resource "netlify_site" "tf-presentation" {
  name = "tf-presentation"

  repo {
    repo_branch = "master"
    command = "yarn build"
    deploy_key_id = netlify_deploy_key.key.id
    dir = "public"
    provider = "github"
    repo_path = "marmorag/terraform-presentation"
  }
}