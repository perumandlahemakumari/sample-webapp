# Sample Web Application - End-to-End CI/CD Pipeline with Jenkins, Docker, SonarQube, and ArgoCD on EKS

This project demonstrates a complete CI/CD pipeline for a Java-based web application, using industry-standard DevOps tools like Jenkins, Docker, SonarQube, Maven, Kubernetes, ArgoCD, and AWS EKS.

## 📌 Summary

This end-to-end Jenkins pipeline automates the complete CI/CD process for a Java application — from code checkout to production deployment. The pipeline uses the following tools and platforms:

- **GitHub** – Source code version control
- **Jenkins** – CI/CD orchestration
- **Maven** – Build automation
- **SonarQube** – Code quality scanning
- **Docker** – Containerization
- **Docker Hub** – Container registry
- **Kubernetes (EKS)** – Container orchestration
- **ArgoCD** – GitOps-based deployment

---

## ✅ Pre-requisites

### 1. Application Code

- Java application hosted in a GitHub repository (this repo).

### 2. Server Requirements

- A **Linux EC2 instance (t2.large)** to set up:
  - Jenkins
  - Docker
  - SonarQube

- An **Amazon EKS (Elastic Kubernetes Service)** cluster to deploy the containerized application.

### 3. Software Requirements

| Tool        | Purpose                                   |
|-------------|-------------------------------------------|
| Jenkins     | Automation server for CI/CD               |
| Docker      | Containerization of the application       |
| Maven       | Java project build tool                   |
| SonarQube   | Static code analysis                      |
| AWS CLI     | AWS resource management                   |
| eksctl      | Create & manage EKS clusters              |
| kubectl     | Kubernetes CLI                            |
| ArgoCD      | GitOps deployment into Kubernetes cluster |

---

## 🛠️ Setup & Installation

### 1. Clone the Repository

```bash
git clone https://github.com/perumandlahemakumari/sample-webapp.git
cd sample-webapp
```

### 2. Launch Jenkins Server (EC2)

- Create a **t2.large** Linux EC2 instance.
- Install:
  - Java 11
  - Jenkins
  - Docker
  - Maven
  - SonarQube
  - AWS CLI
  - kubectl and eksctl

### 3. Configure Jenkins

- Install the following Jenkins plugins:
  - Docker Pipeline
  - Git
  - Maven Integration
  - Kubernetes CLI
  - Blue Ocean
  - SonarQube Scanner
  - AWS Credentials
  - ArgoCD plugin

- Add Jenkins credentials:
  - GitHub access token
  - Docker Hub credentials
  - AWS access and secret keys
  - SonarQube token

---

## 🔁 CI/CD Pipeline Flow

The Jenkins pipeline defined in `Jenkinsfile` performs the following steps:

### 📦 CI - Continuous Integration

1. **Checkout Code**  
   Jenkins clones the Java application from GitHub.

2. **SonarQube Code Analysis**  
   Code is analyzed using SonarQube for bugs, vulnerabilities, and code smells.

3. **Build with Maven**  
   The application is compiled, unit tests are run, and artifacts are generated.

4. **Build Docker Image**  
   A Docker image is built from the application using the provided `Dockerfile`.

5. **Push to Docker Hub**  
   The Docker image is tagged and pushed to your Docker Hub repository.

### 🚀 CD - Continuous Deployment

6. **Update Kubernetes Manifests**  
   The Kubernetes deployment files in `deploymentfiles/` are updated with the new image tag and committed to GitHub (ArgoCD watches this repo).

7. **ArgoCD Deployment to EKS**  
   ArgoCD automatically syncs changes from the repo to the EKS cluster and deploys the updated application.

---

## 📁 Project Structure

```
sample-webapp/
├── SampleWebApplication/      # Java application source code
├── deploymentfiles/           # Kubernetes YAML manifests
├── Dockerfile                 # Docker image definition
├── Jenkinsfile                # Jenkins pipeline definition
└── README.md                  # Project documentation
```

---

## ☸️ EKS & ArgoCD Setup Overview

> For full step-by-step instructions, refer to official documentation.

### 1. Create EKS Cluster

```bash
eksctl create cluster --name demo-cluster --region us-east-1 --nodes 2
```

### 2. Install ArgoCD on EKS

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Login via browser at `https://localhost:8080`.

---

## 📤 Docker Image Push (Optional)

Update your Jenkinsfile to replace `your-dockerhub-username`:

```groovy
docker.image('your-dockerhub-username/sample-webapp').push("${BUILD_NUMBER}")
```

---

## 🔐 Security & Credentials

Ensure that Jenkins and ArgoCD are secured with authentication and SSL.
Use encrypted credentials in Jenkins to avoid hardcoding sensitive data.

---

## ✅ Useful Commands

### Jenkins CLI

```bash
java -jar jenkins-cli.jar -s http://localhost:8080/ list-jobs
```

### Docker

```bash
docker build -t sample-webapp .
docker run -p 8080:8080 sample-webapp
```

### Kubernetes

```bash
kubectl get all
kubectl apply -f deploymentfiles/
```

---

## 🙌 Contributing

1. Fork the repo
2. Create a new branch: `git checkout -b feature-xyz`
3. Commit your changes
4. Push to the branch: `git push origin feature-xyz`
5. Open a Pull Request

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙋‍♀️ Maintainer

**Hema Kumari Perumandla**  
🔗 [GitHub](https://github.com/perumandlahemakumari)
