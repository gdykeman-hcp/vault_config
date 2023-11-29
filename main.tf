terraform {
required_providers {
  vault = "~> 3.7.0"
  }
}

provider "vault" {
  auth_login {
      path = "auth/userpass/login/${var.vault_username}"
      namespace = "admin"
      parameters = {
        password = var.vault_password
      }
  }
}

resource "vault_namespace" "namespaces" {
  for_each = var.namespace_definitions
    path = each.key
}

locals {
  auth_backends = flatten([
    for ns,val in var.namespace_definitions : [
      for type in val.auth :{
        namespace = ns
        auth_type = type
      }
  ]])

  secret_backends = flatten([
    for ns,val in var.namespace_definitions : [
      for type in val.secrets :{
        namespace = ns
        secret_type = type
      }
  ]])
}
resource "vault_auth_backend" "auth" {
  for_each = { for val in local.auth_backends : "${val.namespace}.${val.auth_type}" => val }
    namespace = each.value.namespace
    type = each.value.auth_type
}
resource "vault_mount" "secrets" {
  for_each = { for val in local.secret_backends : "${val.namespace}.${val.secret_type}" => val }
    namespace = each.value.namespace
    type = each.value.secret_type
    path = each.value.secret_type
}