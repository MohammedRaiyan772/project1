# RAIYAN MOTORS — DevOps Deployment Project

A hands-on project demonstrating a static website packaged with Docker and deployed to a self-managed Kubernetes cluster on AWS. Terraform is included for reproducible AWS infrastructure provisioning.

## Architecture

1. Develop the website in `website/`.
2. Build the Docker image using `docker/Dockerfile`.
3. Push the image to Docker Hub.
4. Use Terraform in `terraform/` to provision a VPC, public subnet, networking, security group, and three Ubuntu EC2 instances.
5. Configure Kubernetes on the instances (cluster installation/bootstrap is a separate manual step in this project).
6. Deploy the application using the manifests in `kubernetes/`.
7. Expose the app using a NodePort Service on TCP port `30080`.

> **Source accuracy note:** This is an organized, reproducible project package reconstructed from the project workflow and configuration details available in the conversation. The original website files and complete original Terraform files were not available to copy byte-for-byte. The website and Terraform configuration here are clean reference implementations. Review and adapt them to match the exact AWS resources you created before claiming they are an exact export of your original environment.

## Repository layout

```text
RAIYAN-MOTORS-DevOps-Project1/
├── website/
│   └── index.html
├── docker/
│   └── Dockerfile
├── terraform/
│   ├── versions.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── kubernetes/
│   ├── deployment.yml
│   └── service.yml
├── docs/
│   └── deployment-notes.md
├── .gitignore
└── README.md
```

## Prerequisites

- AWS account and AWS CLI credentials configured locally (do not put credentials in this repository).
- Terraform 1.5+.
- An existing EC2 key pair in the selected AWS region.
- Docker.
- A Docker Hub account.
- `kubectl` and a Kubernetes cluster.

## 1. Build and publish the website image

From the repository root:

```bash
docker build -t YOUR_DOCKERHUB_USERNAME/raiyan-motors:v1 -f docker/Dockerfile website
docker login
docker push YOUR_DOCKERHUB_USERNAME/raiyan-motors:v1
```

Update `image:` in `kubernetes/deployment.yml` to the image you pushed. The conversation project used `raiyan100/project1:v1`; the manifest retains that image as its default.

## 2. Provision AWS infrastructure with Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set:
- `key_name` to an existing EC2 key pair name in the selected region.
- `admin_cidr` to your public IP in CIDR form, for example `203.0.113.10/32` (replace with your real IP).
- `instance_type` to a size suitable for your Kubernetes practice.

Then run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

This Terraform example creates three EC2 instances in one public subnet. It does **not** install or bootstrap Kubernetes automatically; cluster installation and joining nodes are documented as a separate operational step.

To remove resources created by this Terraform configuration:

```bash
terraform destroy
```

Only run `destroy` if this Terraform state manages the resources and you intend to delete them. Do not run it against a state file you do not understand.

## 3. Configure Kubernetes

Install and configure Kubernetes on the three Ubuntu instances using your chosen Kubernetes installation procedure. Initialize one control-plane node, join the two worker nodes, configure a CNI plugin, and verify:

```bash
kubectl get nodes -o wide
```

Expected project layout:
- one control-plane node
- two worker nodes

The exact private IPs and hostnames will differ when Terraform creates new instances.

## 4. Deploy the application

From the repository root, after the cluster is healthy and the image name is correct:

```bash
kubectl apply -f kubernetes/deployment.yml
kubectl apply -f kubernetes/service.yml
kubectl get deployments
kubectl get pods -o wide
kubectl get services
```

The Deployment requests two replicas. A topology spread constraint asks Kubernetes to distribute matching Pods evenly across eligible nodes when possible. The Service uses NodePort `30080`.

Open TCP `30080` in the worker-node security group only from trusted client IPs. Browse to:

```text
http://WORKER_PUBLIC_IP:30080
```

Try each worker's public IP. NodePort is exposed on each node; kube-proxy routes traffic to the Service's ready Pods.

## 5. GitHub upload

From the repository root:

```bash
git init
git add .
git commit -m "Add RAIYAN MOTORS DevOps project"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/RAIYAN-MOTORS-DevOps-Project1.git
git push -u origin main
```

## Security checklist before publishing

- Never commit AWS access keys, passwords, private keys, `.pem`/`.ppk` files, kubeconfig files, or Terraform state.
- `terraform.tfvars` is ignored by `.gitignore`; publish only `terraform.tfvars.example`.
- Restrict SSH and NodePort ingress to your own IP or a trusted network.
- Do not publish real public IPs, private IPs, account IDs, or other environment-specific identifiers in screenshots unless you intend them to be public.
- Check the repository with a secret scanner before making it public.

## Suggested resume project entry

**RAIYAN MOTORS — Containerized Website Deployment on AWS Kubernetes**
- Built and containerized a static website using Docker and published the image to Docker Hub.
- Provisioned AWS networking and EC2 infrastructure using Terraform.
- Configured a Kubernetes cluster with one control-plane node and two worker nodes.
- Deployed the application using Kubernetes Deployments and exposed it through a NodePort Service.
- Used replica management and topology spread constraints to maintain and distribute application Pods.

Only include statements that you personally performed and can explain in an interview.
