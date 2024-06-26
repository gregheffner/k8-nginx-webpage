# Kuberbetes (K8) nginx webpage

There are 3 readme.md files (steps) in this repo. This one shows how to install. The second step configures the cluster. The third step sets up monitoring with Lens. 

Check out the kubernetes_glossary.pdf for reference on any terms

## Prerequisites
1. Three servers running an Ubuntu OS I used a VM and 2 physical PC's reimaged 
2. Minimum 2 GB RAM and 2 Core CPUs on each node
3. A root password configured on each server

# The following steps will be done on all servers. 

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
Next, you will need to update the cgroupdriver
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

# On the main server only run the following commands: 

## Initialize Kubernetes
```bash
sudo kubeadm init --pod-network-cidr=10.69.0.0/16
```

# VERY IMPORTANT
## Copy the cubeadm join full command and save for later 

## Configure Kubernetes
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Deploy Pod Network
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

# Go back to your worker nodes (not the main):

## Step 4 – Join Worker Nodes to the Kubernetes Cluster
Your cubeadm join command should look like this:
```bash
kubeadm join 192.168.1.1:6989 --token blahhhxx5t2f66cpqz8e --discovery-token-ca-cert-hash shaxxxxxxxxxxxxxxxxxxxx
```

# Go back to main server and validate

## Step 5: Verify Installation
```bash
kubectl get pods --all-namespaces
```
