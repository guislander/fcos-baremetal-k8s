// Match a bare-metal machine
resource "matchbox_group" "node1" {
  name = "node1"
  profile = matchbox_profile.container-linux-install.name
  selector = {
    mac = "00:0C:29:04:42:32"
  }
  metadata = {
    custom_variable = "machine_specific_value_here"
    ssh_authorized_key = var.ssh_authorized_key
  }
}
