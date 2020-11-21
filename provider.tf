provider "matchbox" {
  endpoint    = "matchbox.sabana.com:8081"
  client_cert = file("~/.config/matchbox/client.crt")
  client_key  = file("~/.config/matchbox/client.key")
  ca          = file("~/.config/matchbox/ca.crt")
}

provider "ct" {
}

terraform {
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.6.1"
    }
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.4.1"
    }
  }
}
