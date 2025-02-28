# Litmus Ollama Containers

This repository provides Docker images for running Ollama with different models, built and published to **GitHub Container Registry (GHCR)** using GitHub Actions.

## Features
- **Automated builds**: GitHub Actions builds and pushes container images based on `config.yaml`.
- **Supports multiple models**: Easily configure different versions of Ollama and models.
- **CPU & GPU support**: Run on both CPU and GPU using Docker Compose.
- **Public container registry**: Anyone can pull pre-built images from GHCR.

## Repository Structure
```
├── config.yaml                # YAML configuration for image builds
├── build.sh                   # Script to build and push images
├── Dockerfile                 # Dockerfile template for building images
├── .github/workflows/build.yml # GitHub Actions workflow
├── docker-compose-cpu.yml      # Example Docker Compose (CPU mode)
├── docker-compose-gpu.yml      # Example Docker Compose (GPU mode)
└── README.md                   # This file
```

---

## Configuration (config.yaml)
The `config.yaml` defines which Ollama versions and models to include in each container.

Example:
```yaml
containers:
  - ImageName: litmus-ollama-nomic
    Ollama: 0.5.2
    Models:
      - nomic-embed-text:latest
  
  - ImageName: litmus-ollama-mistral
    Ollama: 0.5.2
    Models:
      - mistral:latest
```

---

## How It Works
1. **GitHub Actions** automatically builds images when `config.yaml` is updated.
2. Images are pushed to **GitHub Container Registry (GHCR)**.
3. Anyone can pull and run the containers.

---

## Building and Pushing Images Manually
To build and push images manually (if needed):
```bash
chmod +x build.sh
./build.sh
```
> Note: GitHub Actions automates this process when changes are pushed.

---

## Pulling & Running Containers
### **1️⃣ Pull from GitHub Container Registry**
```bash
docker pull ghcr.io/litmusautomation/litmus-ollama-deepseek:latest
```

### **2️⃣ Run in CPU Mode**
```bash
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ghcr.io/litmusautomation/litmus-ollama-deepseek:latest
```

### **3️⃣ Run in GPU Mode**
```bash
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ghcr.io/litmusautomation/litmus-ollama-llama3:latest
```

---

## Running with Docker Compose
### **CPU Mode**
```bash
docker-compose -f docker-compose.cpu.yml up -d
```

### **GPU Mode**
```bash
docker-compose -f docker-compose.gpu.yml up -d
```

## License

Copyright (c) Litmus Automation Inc.


