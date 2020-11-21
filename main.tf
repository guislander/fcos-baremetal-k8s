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
  ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9t+kc0ALu7225vgTi3itCHEHOEwjkDBGto93O7yKcqKg65XkHPttjmh2knQDLq8jbCjuE9yI+ic+vm0R+snul6HPNTDRgEoJT3kWseHbljL3M4x6Spsl++dhLW+pUNEWzI+WaOFYKTjpuhEtVzCW747KzGWk1tNZfQhH71qcfkLbEPPhdI68f6cqG/qGnYgAG1jKkbqzSTB30aRIc0VLkFHcYey96IPpZ82PM0Gn8IAWaB5Y/xkVeLO9FgYrC9jzr2GlSg3vrFGHEUbK4BGs9SFuUhXJhNxn8R90h8DrZlPCQ7eo+JzQO2+KphhAKW+gozOkSAoEwqhCnZO20vUrAwI+gkCwLToWMJAWkf4ziyDJwaeLmZ4r0+DoIvk8Ch9zjKkXO15XS5UY/oxquLZeTNwiFVGnu2VeFnuoyIwa72MxUFio+DxP4eCLSCPNeF5V6rPppRlkHvfEC77NogipTdNw5ZrZqO00DYD6k6pusk7VkGm8ApaCmUubDJiFKBGk= lcalvo@GuIslander-MBP.sabana.com"

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
