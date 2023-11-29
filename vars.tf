variable "vault_username" {}

variable "vault_password" {}

variable "namespace_definitions" {
  type = map(object({
    secrets   = list(string)
    auth = list(string)
    users = list(string)
  }))
  default = {
    "engineering" = {
      secrets   = ["kv", "transit", "ssh"]
      auth = ["userpass"]
      users = ["eng_dev", "eng_prod"]
    },
    "cloud" = {
      secrets   = ["kv", "aws", "azure"]
      auth = ["userpass"]
      users = ["aws", "azure"]
    },
    "developer" = {
      secrets = ["kv", "transit"]
      auth = ["userpass", "approle"]
      users = ["dev", "app"]
    }
  }
}

