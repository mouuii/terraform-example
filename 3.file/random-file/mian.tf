terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}


resource "random_string" "random" {
  length  = 6
  lower   = true
  special = false
}


resource "local_file" "file" {
  content  = var.content
  filename = "${path.root}/.result/${var.prefix}.${random_string.random.result}.txt"
}