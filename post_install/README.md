# Post Install steps to run a nginx webserver with high availability and secured through a Cloudflare Tunnel. You will need to have a cloudflare account and be able to edit your DNS Settings in cloudflare for this site.

# This will have a 4 pod deployment with a max 10 pod autoscale

Once you have Kubernetes installed and running, download the four files in this repo. 

## Files in this repository

1. `Deployment.yaml` - This is the configuration for your deployment. It contains all the settings you need such as initial pod counts, mount points, and Docker image settings.  
2. `Configmap.yaml` - This is where you will store your HTML code.
3. `Service.yaml` - This will open the ports from the cluster to be available externally from the cluster to your LAN.
4. `Autoscale.yaml` - This configures autoscaling based on a 50% CPU threshold.

## Steps to deploy

1. Clone this repository to your local machine using the following command:

```bash
git clone <repository-url>

```bash
git clone this URL
```
2. Navigate to the directory containing the YAML files:

3. Apply each YAML file using the kubectl apply -f <filename> command. Here are the commands for each file:
```bash
kubectl apply -f Deployment.yaml
kubectl apply -f Configmap.yaml
kubectl apply -f Service.yaml
kubectl apply -f Autoscale.yaml
```

4. Verify the deployment, service, and autoscaling are running correctly with `kubectl get deployments`, `kubectl get services`, and `kubectl get hpa` respectively.

5. Once everything is running correctly, you can access your nginx webserver through the external IP provided by the service.

## Accessing the nginx webserver
```bash
kubectl get services
```
Find the IP and port used. Make sure your local firewall allows the traffic.

## Troubleshooting

If you encounter any issues during the deployment, you can use the `kubectl describe` command followed by the resource type and name to get more information. For example, `kubectl describe deployment <deployment-name>`.


## Installing Cloudflared on Ubuntu

Cloudflared is the software that creates a secure connection between your server and the Cloudflare network. Here's how to install it on Ubuntu:

1. First, download the latest version of Cloudflared:

```bash
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
```
Once the download is complete, install the package:

```bash
sudo dpkg -i cloudflared-stable-linux-amd64.deb
```
2. Setting up the Cloudflare Tunnel
```bash
cloudflared tunnel login
```
After you login create the tunnel and name it something
```bash
cloudflared tunnel create nginxHTML
```
4. Configure the tunnel to route traffic from your domain to your local web server:
```bash
cloudflared tunnel route dns nginxHTML your.webpage.fqdn
```
5. Run the tunnel:
```bash
cloudflared tunnel run nginxHTML
```

## Conclusion

With these steps, you should have a highly available nginx webserver secured through a Cloudflare Tunnel. If you have any questions or issues, please open an issue in this repository.