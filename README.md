# Web Server on Kubernetes using Terraform, CI/CD, and GitOps
This repository contains the infrastructure and setup for deploying a Node.js Web Server on Amazon EKS (Elastic Kubernetes Service) using Infrastructure as Code (IaC), CI/CD pipelines, and GitOps practices with ArgoCD.

**System Overview**
- The project involves deploying a simple Node.js web server to Amazon EKS.
- Use Terraform to manage the cloud infrastructure
- GitHub Actions to handle CI/CD
- ArgoCD for GitOps-based continuous deployment.
- The web server is exposed via an AWS Load Balancer and is accessible from the internet.

## 1. Create a GitHub Repository
The project is hosted in a GitHub repository. The repository includes the following:
- Terraform files to create and manage AWS resources (EKS, VPC, IAM roles, etc.)
- Node.js Web Application for deployment on EKS.
- CI/CD pipeline configuration using GitHub Actions to automate Docker image building, pushing to ECR, and updating Kubernetes deployments.

## 2. Infrastructure Setup
Terraform is used to define the infrastructure:
- Amazon EKS Cluster: Managed Kubernetes cluster.
- VPC: Virtual Private Cloud to manage network configuration.
- IAM roles: To assign the appropriate permissions for services such as EKS, EC2, and load balancers.
- Namespace and Service Account: A specific Kubernetes namespace (webserver) is created, along with a service account (web-sa) that has the required permissions.

## 3. Simple Web Server Implementation (Node.js)
The Node.js web server runs on port 3000 inside a Docker container. The application is a simple "Hello World" response:
```
app.get("/", (req, res) => {
  res.send("Hello from Node.js running in Kubernetes!");
});
```

## 4. CI/CD Pipeline with GitHub Actions
The GitHub Actions workflow automates the build, push, and deployment process for the web server.

![image](https://github.com/user-attachments/assets/f3cf677a-4e7b-4766-b5b2-80cc81e41ea2)


**Workflow:**
- **build-push**: Builds a Docker image for the web server and pushes it to Amazon ECR (Elastic Container Registry).

- **update-gitops**: Updates the Kubernetes deployment manifest stored in the repository to reflect the latest Docker image pushed to ECR. It ensures that ArgoCD can sync the updated deployment

## 5. ArgoCD Integration
- ArgoCD is used to manage the Kubernetes deployment in a GitOps fashion.
- The ArgoCD Application is defined in argocd-app.yaml. It monitors the kubernetes directory in the GitHub repository and ensures that the Kubernetes cluster is always synchronized with the declared state.
- ArgoCD automatically synchronizes the web server deployment and updates the image when changes are pushed to the main branch of the repository.

![image](https://github.com/user-attachments/assets/16f9ef41-4261-415b-836f-72192c4e3fba)
- **webserver-app**: ArgoCD Application - Manages the entire deployment of your web server application
- **webserver-service**: Kubernetes Service - Exposes the web server to the outside world
- **web-sa**: ServiceAccount - Used by Kubernetes to manage the identity for processes running inside the pod
- **webserver**: Deployment - Kubernetes resource that defines how to run and manage the web server application
- **webserver-service**: Endpoints - Connects the Service to the actual running pods. It keeps track of the IP addresses of the pods that the Service should route traffic to
- **webserver-service-t4bl6**: EndpointSlice - Divides the list of endpoints into smaller, more manageable slices, making it easier to scale and more efficient to manage.
- **webserver-555cf55575 & webserver-59f77fb4b5**: ReplicaSet - Ensures that a specified number of identical pods are running at any time
- **webserver-555cf55575-rrnbz & webserver-555cf55575-zm24x**: Pod - Running the web server container


## 6. Exposing the Web Server
- The web server is exposed to the internet using a LoadBalancer Service. Once the deployment is completed and the service is available, you can access the web server by visiting the URL provided by the LoadBalancer.

**Key Resources:**
- Ingress: Configured with annotations to use an AWS ALB to expose the service.
- Service: A LoadBalancer type service is defined to expose the web server on port 80.
- DNS: A DNS is set for the web server to be accessible over the internet.

## 7. Security
- AWS Secrets Manager: Credentials for ECR are securely stored in GitHub Secrets and are accessed during the CI/CD pipeline execution.

## 8. Web Server Access
After successful deployment, the web server should be accessible at an external IP, provided by the AWS Load Balancer.

Webhttp://a15f13353389c4bc2aeb8083a8b7c8ba-230519834.us-east-1.elb.amazonaws.com/

[URL](http://a15f13353389c4bc2aeb8083a8b7c8ba-230519834.us-east-1.elb.amazonaws.com/)


# How to Replicate and Run the Project
## Prerequisites
Before getting started, make sure you have the following tools installed:

Git: Version control system for cloning the repository.
Docker: To build and manage containers.
Terraform: To create and manage AWS resources.
kubectl: To manage Kubernetes clusters.
AWS CLI: To interact with AWS services from the command line.
GitHub Actions (for CI/CD): This is handled by the GitHub Actions workflow.

1. Clone the repository:
   ```
   git clone https://github.com/BenArtzi4/iac-eks-webserver.git
   cd iac-eks-webserver
   ```

2. Set up AWS CLI: Ensure your AWS CLI is configured with the correct credentials:
   ```
   aws configure
   ```
3. Set up ECR (Elastic Container Registry) - Create a repository on Amazon ECR
   ```
   aws ecr create-repository --repository-name webserver
   ```
4. Create the EKS (Amazon Elastic Kubernetes) Cluster
   ```
   terraform init
   terraform apply -auto-approve
   ```
5. Deploy the Web Server using ArgoCD: After the EKS cluster is ready, the Kubernetes deployment will be updated automatically when new Docker images are pushed to ECR

6. Verify the deployment verify the service is running using `kubectl`:
   ```
   kubectl get svc -n webserver
   ```

# Architecture Diagram

![image](https://github.com/user-attachments/assets/72aa1a13-a010-4dc4-8cea-91b0d1322d18)




