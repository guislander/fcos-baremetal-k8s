provider "matchbox" {
  version = "0.3.0"
  endpoint    = "matchbox.sabana.com:8081"
  client_cert = file("~/.config/matchbox/client.crt")
  client_key  = file("~/.config/matchbox/client.key")
  ca          = file("~/.config/matchbox/ca.crt")
}
