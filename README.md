# Kubernetes Installation Guide on Ubuntu 22.04

## Prerequisites
-Three servers running an Ubuntu OS
-Minimum 2 GB RAM and 2 Core CPUs on each node
-A root password configured on each server

## Update System Packages
First, update the system packages with the following command:
```bash
sudo apt-get update
```

## Step 1 – Disable Swap and Enable IP Forwarding
First, turn swap off:
```bash
swapoff -a
```
Edit permanently
```bash
nano /etc/fstab
```
Comment out 
#/swapfile  

Next, edit the /etc/sysctl.conf file to enable the IP forwarding:
```bash
nano /etc/sysctl.conf
```
Uncomment this line below
"net.ipv4.ip_forward = 1"

Apply settings
```bash
sysctl -p
```

## Step 2: Install Docker
Kubernetes requires Docker to be installed on the system. Install Docker with the following commands:
```bash
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install docker-ce -y
```

## Step 3: Install Kubernetes
Now, install Kubernetes with the following commands:
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install kubelet kubeadm kubectl -y
```
Next, you will need to update the cgroupdriver on all nodes. You can do it by creating the following file:
```bash
nano /etc/docker/daemon.json
```
Add the following lines:
```bash
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
```
Save and reload:
```bash
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
```
## Step 4: Initialize Kubernetes
```bash
sudo kubeadm init --pod-network-cidr=10.69.0.0/16
```

# Copy the ubeadm join full command and save for later

## Step 5: Configure Kubernetes
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Step 6: Deploy Pod Network
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

## Step 7 – Join Worker Nodes to the Kubernetes Cluster
Your cubeadm join command should look like this:
```bash
kubeadm join 192.168.1.1:6989 --token blahhhxx5t2f66cpqz8e --discovery-token-ca-cert-hash shaxxxxxxxxxxxxxxxxxxxx
```

## Step 8: Verify Installation
```bash
kubectl get pods --all-namespaces
```
