# 🧾 Certificate Expiry Date Checker (Bash Version)

This project provides a **simple Bash script** to automatically check and display the **SSL/TLS certificate expiry dates** for a list of websites.  
It can run locally, inside a **Docker container**, or on **Kubernetes** (e.g., Minikube).
<br><br>
Note: the check_ssl_expiry.py script is the Python version of this functionality and it contains an email alerts feature.

---

## 📋 Overview

The script:

1. Reads a list of websites from a config file (`domains.txt`)
2. Connects to each website via HTTPS (port 443)
3. Retrieves the SSL certificate using `openssl`
4. Extracts and prints the certificate’s **expiration date**
5. Shows how many days are left until expiry (or how many days ago it expired)
6. Handles errors when a site can’t be reached or doesn’t have a valid certificate

---

## 🧱 Project Structure

1. check_ssl_expiry.sh # Main Bash script to check SSL certificate expiry
2. domains.txt # List of websites to check
3. Dockerfile # Container setup for Docker/Kubernetes
4. deployment.yaml # Kubernetes deployment configuration

---

## ⚙️ Prerequisites

To run locally:

- Linux, macOS, or Windows (with Git Bash / WSL)
- `openssl` and `bash` installed  
  (already included in most systems)

To build and run in Docker:

- [Docker Desktop](https://www.docker.com/products/docker-desktop)

To deploy in Kubernetes:

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## 🧩 Usage (Local)

1. Make the script executable:
   ```bash
   chmod +x check_ssl_expiry.sh
   ```
2. Run the script:
   ```bash
    ./check_ssl_expiry.sh
   ```
3. The script will read `domains.txt` and print expiry info for each domain. Example output:
   ```bash
   Checking SSL certificate for google.com ...
   Certificate will expire in 61 days
   Checking SSL certificate for github.com ...
   Certificate will expire in 93 days
   Checking SSL certificate for expired.badssl.com ...
   Certificate expired 3858 days ago
   ```

## 🐳 Usage (Docker)

1. Build the Docker image:
   ```bash
   docker build -t ssl-checker .
   ```
2. Run the Docker container:
   ```bash
    docker run --rm ssl-checker
   ```
   Example output:
   ```bash
   Checking SSL certificate for google.com ...
   Certificate will expire in 61 days
   Checking SSL certificate for github.com ...
   Certificate will expire in 93 days
   Checking SSL certificate for expired.badssl.com ...
   Certificate expired 3858 days ago
   ```

## ☸️ Usage Kubernetes (Minikube)

1. Start Minikube:
   ```bash
   minikube start
   ```
2. Build the Docker image inside Minikube:
   ```bash
   eval $(minikube docker-env)
   docker build -t ssl-checker .
   ```
3. Apply the Kubernetes deployment:
   ```bash
    kubectl apply -f deployment.yaml
   ```
4. Check the logs of the executing pod:
   ```bash
   kubectl logs -l app=ssl-checker
   ```
   Example output:
   ```bash
   Checking SSL certificate for google.com ...
   Certificate will expire in 61 days
   Checking SSL certificate for github.com ...
   Certificate will expire in 93 days
   Checking SSL certificate for expired.badssl.com ...
   Certificate expired 3858 days ago
   ```

---

## 🧹 Clean Up

To remove the deployment from Kubernetes, run:

```bash
kubectl delete deployment ssl-checker
```

To stop Minikube, run:

```bash
minikube stop
```

---

## 📄 Resources Used

For the script, the following resources were referenced:

- [Looping through the content of a file in Bash](https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash)
- [Calculating date differences in Bash](https://askubuntu.com/questions/1198619/bash-script-to-calculate-remaining-days-to-expire-ssl-certs-in-a-website)
- [Empty String check in Bash](https://stackoverflow.com/questions/13509508/check-if-string-is-neither-empty-nor-space-in-shell-script)
- [Config file existence check in Bash](https://stackoverflow.com/questions/59579505/need-help-to-write-shell-script-to-check-if-file-exist-or-not)

For Docker/Kubernetes setup:

- ChatGPT assistance
- [Kubernetes Deployment documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
