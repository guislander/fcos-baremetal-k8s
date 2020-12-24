module "myk8s" {
  source = "git::https://github.com/guislander/typhoon//bare-metal/fedora-coreos/kubernetes"
  #source = "./typhoon//bare-metal/fedora-coreos/kubernetes"

  # bare-metal
  cluster_name            = "k8s"
  matchbox_http_endpoint  = "http://matchbox.sabana.com:8080"
  os_stream               = "stable"
  os_version              = "32.20200601.3.0"

  # configuration
  k8s_domain_name    = "node1.sabana.com"
  ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxyRa+tN0uDM5o4QZbWEQxZ1g09wwGuOWS9mfZzf0Gw9mCcsdl1rhyVHfSyv8qsTpZdmHaSr13TKtMxgEzK+Ay4PIae4emLMAz+YJRc0b+kRZkiq9yykdnPdnGp5ekTX8zTWwnWf0xHN9yna8MNscuKrs045jVBQ8tQ6KrF0OaseR0BnxBRJ6TBvK527cXtm5ANk7tq7hAq6/27OA4w1avaZh7AWa7pwdTekb5gE5+6UtpkGg1VDOsLSdhyonfJp4bHETD4/4bTHrxfhue4i7jvfDBjjunMVA/P6q5AZ0LQVBHv/t7S1trCc16KPZBf7qsPS4MQ+iJD1197iJtxdgG1lKz/gr7HB/mwtrylZv6F/6XnY87EZLyT5ulaSqPEAVv6xCiXHY5r3fxFYdnOM18LTBujZz8ZKYGQPkyXGpiL2DX7PWaRW3jvztq+/z6W9fSQqFH6XbIULs35JMsjZyV4jJKG4vi7yJFiz73BNB7bmIyYV4JpXaAT9hOgLHFHr0= lcalvo@GuIslander-MBP.sabana.com"

  # machines

  controllers = [{
    name   = "node1"
    mac    = "3C:EC:EF:02:BA:34"
    domain = "node1.sabana.com"
  }]
  workers = [
    {
      name   = "node2",
      mac    = "3C:EC:EF:0C:20:46"
      domain = "node2.sabana.com"
    },
    {
      name   = "node3",
      mac    = "3C:EC:EF:0C:1E:20"
      domain = "node3.sabana.com"
    }
  ]

  # additional machine config

   snippets = {
     "node1" = [
       file("./snippets/master-networking.yaml")
     ],
     "node2" = [
       file("./snippets/worker-disks.yaml"),
       file("./snippets/worker-volumes.yaml"),
       file("./snippets/worker-networking.yaml"),
       file("./snippets/worker-selinux.yaml"),
       file("./snippets/worker-iptables-policy.yaml"),
     ],
     "node3" = [
       file("./snippets/worker-disks.yaml"),
       file("./snippets/worker-volumes.yaml"),
       file("./snippets/worker-networking.yaml"),
       file("./snippets/worker-selinux.yaml"),
       file("./snippets/worker-iptables-policy.yaml"),
     ]
   }

  # enable k8s extension api aggregation
  enable_aggregation = true

  # nvme boot drive /dev/nvme0n1
  install_disk = "/dev/nvme0n1"

  #cached_install = true
}

# obtain cluster kubeconfig
resource "local_file" "kubeconfig-myk8s" {
  content  = module.myk8s.kubeconfig-admin
  filename = "/Users/lcalvo/.kube/configs/myk8s-config"
}
