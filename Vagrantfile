Vagrant.configure("2") do |k8s_lab|
   k8s_lab.vm.define "master01" do |master01|
      master01.vm.provider "vmware_desktop" do |v|
         v.cpus = 2
         v.memory = 4096
         v.allowlist_verified = true
      end
      master01.vm.box = "generic/rocky8"
      master01.vm.hostname = "master01.9prints.internal"
      master01.vm.network "private_network", ip: "10.10.1.101"
      master01.vm.synced_folder ".", "/vagrant"
      master01.vm.provision "shell", path: "k8s_setup.sh"
      end
   k8s_lab.vm.define "worker01" do |worker01|
      worker01.vm.provider "vmware_desktop" do |v|
         v.cpus = 2
         v.memory = 4096
         v.allowlist_verified = true
      end
      worker01.vm.box = "generic/rocky8"
      worker01.vm.hostname = "worker01.9prints.internal"
      worker01.vm.network "private_network", ip: "10.10.1.102"
      worker01.vm.synced_folder ".", "/vagrant"
      worker01.vm.provision "shell", path: "k8s_setup.sh"
      end
   k8s_lab.vm.define "worker02" do |worker02|
      worker02.vm.provider "vmware_desktop" do |v|
         v.cpus = 2
         v.memory = 4096
         v.allowlist_verified = true
      end
      worker02.vm.box = "generic/rocky8"
      worker02.vm.hostname = "worker02.9prints.internal"
      worker02.vm.network "private_network", ip: "10.10.1.103"
      worker02.vm.synced_folder ".", "/vagrant"
      worker02.vm.provision "shell", path: "k8s_setup.sh"
      end

end

