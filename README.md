# Data Science Docker Workflow

This repository is a personal reference guide for building a reproducible and portable data science workflow with Docker.

The aim is to keep a familiar way of working with GitHub, VS Code, Jupyter notebooks, and Python scripts, while making the development environment more stable, isolated, and reusable across projects and machines.

---

## Prerequisites

### Install Git (Windows)

Download and install Git from:

https://git-scm.com/download/win

Verify installation in PowerShell:

```bash
git --version
```

---

### Install Docker Desktop (Windows)

Download Docker Desktop from:

https://www.docker.com/products/docker-desktop/

During installation:

* Enable WSL 2 integration
* Accept default settings

After installation:

1. Restart your machine
2. Open Docker Desktop
3. Wait until it shows Docker is running

Verify installation:

```bash
docker --version
docker run hello-world
```

---

## 1. Creating a GitHub Repository

Create a new repository on GitHub with the following options:

* Name: `data-science-docker-workflow`
* Visibility: public or private
* Template: none
* Initialize with README: optional
* Add `.gitignore`: no (we create our own)

---

## 2. Cloning the Repository (Windows)

Open PowerShell and navigate to your desired folder:

```bash
cd ~/Documents
```

Clone the repository:

```bash
git clone https://github.com/<your-username>/data-science-docker-workflow.git
cd data-science-docker-workflow
```

### Private repositories

The command is the same, but authentication is required.

Alternatively, use SSH:

```bash
git clone git@github.com:<your-username>/data-science-docker-workflow.git
```

---

## SSH Authentication (Optional but Recommended)

### Check existing keys

```bash
ls ~/.ssh
```

### Generate new key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Start agent and add key

```bash
Start-Service ssh-agent
ssh-add ~/.ssh/id_ed25519
```

### Add key to GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

Paste into:
GitHub → Settings → SSH and GPG keys → New SSH key

### Test connection

```bash
ssh -T git@github.com
```

---

## 3. Open in VS Code

```bash
code .
```

---

## 4. Create `.gitignore`

Create a `.gitignore` file:

```gitignore
# Python
__pycache__/
*.py[cod]

# Environments
.env
.venv
env/
venv/

# Conda
conda-meta/

# Jupyter
.ipynb_checkpoints/

# VS Code
.vscode/

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Docker
*.tar

# Data
data/
```

Commit:

```bash
git add .
git commit -m "Initial setup with README and gitignore"
git push
```

---

## 5. Create Python Environment

### `environment.yml`

```yaml
name: ds-env
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.11
  - pip
  - jupyterlab
  - ipykernel
  - numpy
  - pandas
  - matplotlib
  - scikit-learn
  - pip:
      - -r requirements.txt
```

### `requirements.txt`

```text
# Add pip dependencies here
```

Optional local test:

```bash
conda env create -f environment.yml
conda activate ds-env
```

---

## 6. Docker Setup

### `Dockerfile`

```dockerfile
FROM mambaorg/micromamba:1.5.10

WORKDIR /workspace

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml requirements.txt ./

RUN micromamba create -y -f environment.yml && \
    micromamba clean --all --yes

COPY --chown=$MAMBA_USER:$MAMBA_USER . /workspace

CMD ["bash"]
```

---

### `.dockerignore`

```gitignore
.git
.ipynb_checkpoints
__pycache__
*.pyc
.env
.venv
conda-meta
.vscode
.DS_Store
Thumbs.db
*.log
data
```

---

## 7. Build Docker Image

```bash
docker build -t ds-docker-workflow .
```

---

## Important Note on Workflow

This setup is **not intended for manual terminal usage inside Docker**.

Instead:

* Docker defines the environment
* VS Code is the interface
* Python and Jupyter run inside the container

We do **not rely on activating environments in the shell**.

---

## Next Steps

Next, we will:

* Add a VS Code Dev Container configuration
* Open the project directly inside Docker
* Use the container as the Python environment in VS Code
* Run notebooks seamlessly with the container kernel

This will replace WSL-based workflows and provide a more stable development experience.
