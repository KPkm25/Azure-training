commands
```
    1  apt update
    2  clear
    3  cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

    4  sudo modprobe overlay
    5  sudo modprobe br_netfilter
    6  # sysctl params required by setup, params persist across reboots
    7  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

    8  # Apply sysctl params without reboot
    9  sudo sysctl --system
   10  sudo swapoff -a
   11  KUBERNETES_VERSION=v1.32
   12  CRIO_VERSION=v1.32
   13  # Apply sysctl params without reboot
   14  sudo sysctl --system
   15  sudo apt-get update -y
   16  sudo apt-get install -y apt-transport-https ca-certificates curl gpg
   17  ## Install CRIO Runtime
   18  sudo apt-get update -y
   19  apt-get install -y software-properties-common curl apt-transport-https ca-certificates
   20  curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |     gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
   21  echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |     tee /etc/apt/sources.list.d/cri-o.list
   22  sudo apt-get update -y
   23  sudo apt-get install -y cri-o
   24  sudo systemctl daemon-reload
   25  sudo systemctl enable crio --now
   26  sudo systemctl start crio.service
   27  KUBERNETES_VERSION=v1.32
   28  curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |     gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
   29  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |     tee /etc/apt/sources.list.d/kubernetes.list
   30  sudo apt-get update -y
   31  apt-cache madison kubeadm | tac
   32  KUBERNETES_INSTALL_VERSION=1.32.5-1.1
   33  sudo apt-get install -y kubelet="$KUBERNETES_INSTALL_VERSION" kubectl="$KUBERNETES_INSTALL_VERSION" kubeadm="$KUBERNETES_INSTALL_VERSION"
   34  sudo apt-get install -y kubelet kubeadm kubectl
   35  sudo apt-mark hold kubelet kubeadm kubectl
   36  kubeadm join 172.31.93.12:6443 --token 5yjc5l.qazwij1d926191ov         --discovery-token-ca-cert-hash sha256:125c15bcbc3d6af4a48f14fad8f2db8d6767a3d356af6961baef06a0edf4f89c 
   37  clear
   38  history
   ```