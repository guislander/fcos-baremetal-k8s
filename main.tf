module "myk8s" {
  source = "git::https://github.com/guislander/typhoon//bare-metal/fedora-coreos/kubernetes"
 
  # bare-metal
  cluster_name            = "k8s"
  matchbox_http_endpoint  = "http://matchbox.sabana.com:8080"
  os_stream               = "stable"
  os_version              = "33.20210314.3.0"
  #kernel_args             = ["net.ifnames=0"]

  # configuration
  k8s_domain_name    = "node0.sabana.com"
  ssh_authorized_key = file("~/.ssh/id_ed25519.pub")

  # machines

  controllers = [{
    name   = "node0"
    mac    = "00:25:90:b9:84:41"
    domain = "node0.sabana.com"
  }]
  workers = [
    {
      name   = "node1"
      mac    = "3C:EC:EF:02:BA:34"
      domain = "node1.sabana.com"
    },
    {
      name   = "node2",
      mac    = "3C:EC:EF:0C:20:46"
      domain = "node2.sabana.com"
    },
    {
      name   = "node3",
      mac    = "3C:EC:EF:0C:1E:20"
      domain = "node3.sabana.com"
    },
    {
      name   = "node4",
      mac    = "00:25:90:b9:83:99"
      domain = "node4.sabana.com"
    },
    {
      name   = "node5",
      mac    = "00:25:90:b9:85:81"
      domain = "node5.sabana.com"
    }
  ]

  # additional machine config

  snippets = {
    "node0" = [
      file("./snippets/group1-node-os-disk.yaml")
    ]
    "node1" = [
      file("./snippets/group1-node-os-disk.yaml"),
      file("./snippets/worker-networking.yaml")
    ]
    "node2" = [
      file("./snippets/group1-worker-disks.yaml"),
      file("./snippets/worker-filesystem.yaml"),
      file("./snippets/worker-networking.yaml"),
      file("./snippets/worker-selinux.yaml"),
      file("./snippets/worker-selinux-policy.yaml")
    ]
    "node3" = [
      file("./snippets/group1-worker-disks.yaml"),
      file("./snippets/worker-filesystem.yaml"),
      file("./snippets/worker-networking.yaml"),
      file("./snippets/worker-selinux.yaml"),
      file("./snippets/worker-selinux-policy.yaml")
    ]
    "node4" = [
      file("./snippets/group2-worker-disks.yaml"),
      file("./snippets/worker-filesystem.yaml"),
      file("./snippets/worker-networking.yaml"),
      file("./snippets/worker-selinux.yaml"),
      file("./snippets/worker-selinux-policy.yaml")
    ]
    "node5" = [
      file("./snippets/group2-worker-disks.yaml"),
      file("./snippets/worker-filesystem.yaml"),
      file("./snippets/worker-networking.yaml"),
      file("./snippets/worker-selinux.yaml"),
      file("./snippets/worker-selinux-policy.yaml")
    ]
  }

  # enable k8s extension api aggregation
  enable_aggregation = true

  # nvme boot drive /dev/nvme0n1
  install_disk = "/dev/disk-by-label/os"

  #cached_install = true
}

# obtain cluster kubeconfig
resource "local_file" "kubeconfig-myk8s" {
  content  = module.myk8s.kubeconfig-admin
  filename = "/Users/lcalvo/.kube/configs/myk8s-config"
}
