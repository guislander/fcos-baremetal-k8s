// Create a Container Linux install profile
resource "matchbox_profile" "container-linux-install" {
  name = "container-linux-install"
  kernel = "/assets/coreos/var.container_linux_version/coreos_production_pxe.vmlinuz"
  initrd = [
    "/assets/coreos/var.container_linux_version/coreos_production_pxe_image.cpio.gz"
  ]
  args = [
    "coreos.config.url=http://var.matchbox_http_endpoint/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "coreos.first_boot=yes",
    "console=tty0",
    "console=ttyS0",
    "coreos.autologin"
  ]
  container_linux_config = file("./cl/coreos-install.yaml.tmpl")
}

