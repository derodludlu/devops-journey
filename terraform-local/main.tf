# Local backend: store state on your machine (no cloud)
terraform {
  required_version = ">= 1.0"
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Provider: we'll use the "null" provider for local-only practice
provider "null" {}

# Resource 1: Create a local file with your DevOps journey notes
resource "null_resource" "devops_notes" {
  triggers = {
    # Re-run if this file changes (simple change detection)
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Day 5: Terraform IaC practice - $(date)' >> devops-notes.txt"
  }
}

# Resource 2: Create a config file with your environment info
resource "local_file" "env_config" {
  filename = "${path.module}/env-config.json"
  content = jsonencode({
    project     = "devops-journey"
    environment = "local"
    day         = 5
    tools       = ["docker", "compose", "terraform", "git"]
    timestamp   = timestamp()
  })
}

# Output: Show the path to our generated config
output "config_file_path" {
  value = "${path.module}/env-config.json"
}

# Output: Confirm success message
output "status" {
  value = "✅ Terraform local IaC practice complete"
}