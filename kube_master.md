commands
```
    1  clear
    2  cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

    3  sudo modprobe overlay
    4  sudo modprobe br_netfilter
    5  # sysctl params required by setup, params persist across reboots
    6  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

    7  # Apply sysctl params without reboot
    8  sudo sysctl --system
    9  apt update
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
   36  sudo kubeadm init
   37  mkdir -p $HOME/.kube
   38  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   39  sudo chown $(id -u):$(id -g) $HOME/.kube/config
   40  kubectl get nodes
   41  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
   42  curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O
   43  kubectl get nodes
   44  kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
   45  kubectl get nodes
   46  kubectl -n kube-system get pod -l component=kube-controller-manager -o yaml | grep -i cluster-cidr
   47  nano custom-resources.yaml
   48  kubectl apply -f custom-resources.yaml
   49  kubectl get po -A
   50  kubectl get no
   51  clear
   52  history

   ```