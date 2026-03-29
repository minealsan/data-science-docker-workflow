# Data Science Environment Workflow on Windows

This repository is a personal reference guide for setting up a reproducible data science workflow on Windows.

The main goal is to keep a practical day-to-day setup for notebooks and Python development in VS Code, while still keeping the environment definition reproducible through `environment.yml`.

The recommended default workflow in this guide is:

* use **Conda on Windows** for normal local development
* use `environment.yml` as the source of truth
* optionally use **Docker** and **VS Code Dev Containers** later for containerized workflows

This structure reflects a practical conclusion: while Docker and Dev Containers are powerful, on Windows they add another moving part through Docker Desktop, and when the environment changes often, rebuilding can become fragile or slow.

---

## Prerequisites

### Install Git (Windows)

Download and install Git from:

https://git-scm.com/download/win

Verify installation in PowerShell:

```bash
git --version
```

### Install Miniconda or Anaconda

You can use either:

* Miniconda
* Anaconda

Miniconda is usually enough and keeps the setup lighter.

After installation, verify in PowerShell:

```bash
conda --version
```

### Optional: Install Docker Desktop

Docker is **optional** in this workflow.

Download Docker Desktop from:

https://www.docker.com/products/docker-desktop/

During installation:

* enable WSL 2 integration
* accept default settings

Verify installation:

```bash
docker --version
docker run hello-world
```

---

## 1. Creating a GitHub Repository

Create a normal GitHub repository for this guide.

Recommended choices:

* Repository name: `data-science-docker-workflow`
* Visibility: public or private
* Template: none
* Initialize with README: yes, optional but convenient
* Add `.gitignore`: no, we will create our own
* Choose a license: optional

This repository can contain:

* the setup guide in `README.md`
* environment definition files
* optional Docker and Dev Container files
* a simple notebook for testing the workflow

---

## 2. Cloning the Repository Locally on Windows

Open PowerShell and move to the folder where you want to keep your repositories.

Example:

```bash
cd ~/Documents
```

Then clone the repository using the HTTPS URL from GitHub.

### Public repository

```bash
git clone https://github.com/<your-username>/data-science-docker-workflow.git
cd data-science-docker-workflow
```

### Private repository

The HTTPS command is usually the same:

```bash
git clone https://github.com/<your-username>/data-science-docker-workflow.git
cd data-science-docker-workflow
```

The difference is that GitHub will require authentication.

If SSH is configured, you can also clone with:

```bash
git clone git@github.com:<your-username>/data-science-docker-workflow.git
cd data-science-docker-workflow
```

---

## 3. SSH Authentication (Optional but Recommended)

Using SSH avoids repeated authentication prompts and is especially convenient for private repositories.

### Check if you already have SSH keys

```bash
ls ~/.ssh
```

If you see files such as `id_ed25519` and `id_ed25519.pub`, you already have a key.

### Generate a new SSH key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Press Enter to accept the default location, and optionally set a passphrase.

### Start the SSH agent and add the key

```bash
Start-Service ssh-agent
ssh-add ~/.ssh/id_ed25519
```

### Copy the public key

```bash
cat ~/.ssh/id_ed25519.pub
```

Then go to:

* GitHub → Settings
* SSH and GPG keys
* New SSH key

Paste the key and save it.

### Test the connection

```bash
ssh -T git@github.com
```

---

## 4. Opening the Repository in VS Code

From PowerShell, after moving into the repository folder, open the project in VS Code:

```bash
code .
```

If the `code` command is not available, open VS Code manually and select the repository folder.

---

## 5. Creating a `.gitignore` File

Create a `.gitignore` file in the root of the repository.

```gitignore
# Python
__pycache__/
*.py[cod]
*.pyo
*.pyd

# Virtual environments
.env
.venv
env/
venv/
ENV/

# Conda
conda-meta/

# Jupyter Notebook
.ipynb_checkpoints/

# VS Code
.vscode/

# OS files
.DS_Store
Thumbs.db

# Logs
*.log

# Docker
*.tar
docker-compose.override.yml

# Data (optional)
data/
```

Then commit the initial files:

```bash
git add .
git commit -m "Add initial README and gitignore"
git push
```

---

## 6. Defining the Python Environment

Create an `environment.yml` file in the root of the repository.

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

Create a `requirements.txt` file as well:

```text
# Add pip-only dependencies here
```

This setup gives you:

* Conda-managed core packages
* pip support for extra packages
* a single environment definition file that can be reused across projects

---

## 7. Recommended Default Workflow: Conda on Windows

For normal local work on Windows, this is the recommended workflow.

### Create the environment

```bash
conda env create -f environment.yml
conda activate ds-env
```

### Register the Jupyter kernel

```bash
python -m ipykernel install --user --name ds-env --display-name "Python (ds-env)"
```

### Select the interpreter in VS Code

In VS Code:

1. Press `Ctrl + Shift + P`
2. Search for `Python: Select Interpreter`
3. Choose `ds-env`

For notebooks:

1. Open the notebook
2. Click the kernel selector
3. Choose `Python (ds-env)`

### Why this is the recommended default

This setup is simpler and more stable for day-to-day work on Windows because:

* no container rebuild is needed for normal coding
* no Docker Desktop dependency
* no Dev Container overhead
* environment updates are direct and fast

---

## 8. Updating the Environment

When `environment.yml` changes, do **not** create a new environment unless you really want a fresh one.

Instead, update the existing one:

```bash
conda env update -f environment.yml --prune
```

The `--prune` flag removes packages that are no longer listed in the file, so the environment stays aligned with `environment.yml`.

If you update `requirements.txt` through the pip section in `environment.yml`, this update command will also apply those changes.

### Typical workflow

1. Edit `environment.yml`
2. Run:

```bash
conda env update -f environment.yml --prune
```

3. Restart the notebook kernel if needed
4. Test imports
5. Commit changes

Example:

```bash
git add .
git commit -m "Update environment"
git push
```

---

## 9. Example: Add a Package

Suppose you want to add `seaborn`.

Update `environment.yml`:

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
  - seaborn
  - pip:
      - -r requirements.txt
```

Then update the environment:

```bash
conda env update -f environment.yml --prune
```

Test it in a notebook:

```python
import seaborn as sns
print(sns.__version__)
```

---

## 10. Simple Test Notebook

Create a folder named `notebooks` and add a notebook such as:

```text
notebooks/test_notebook.ipynb
```

In the first cells, run:

```python
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

print("Python executable:", sys.executable)
print("NumPy version:", np.__version__)
print("Pandas version:", pd.__version__)
```

Optional extra cell:

```python
try:
    import seaborn as sns
    print("Seaborn version:", sns.__version__)
except ImportError:
    print("Seaborn not installed")
```

This notebook is enough to confirm that:

* VS Code is using the correct interpreter
* the environment is active
* plotting works
* added packages are available

---

## 11. Optional: Docker-Based Workflow

Docker can be useful when you want:

* stronger reproducibility
* containerized development
* a setup closer to production or team standards
* portability across machines

However, on Windows this comes with extra complexity because Docker Desktop relies on its own backend and adds another infrastructure layer.

### Dockerfile

If you want to keep a Docker version of the setup, create this `Dockerfile`:

```dockerfile
FROM mambaorg/micromamba:1.5.10

WORKDIR /workspace

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml requirements.txt ./

RUN micromamba create -y -f environment.yml && \
    micromamba clean --all --yes

CMD ["sleep", "infinity"]
```

### `.dockerignore`

Create a `.dockerignore` file:

```gitignore
.git
.gitignore
.ipynb_checkpoints
__pycache__
*.pyc
*.pyo
*.pyd
.env
.venv
env
venv
ENV
conda-meta
.vscode
.DS_Store
Thumbs.db
*.log
data
```

### Build the image manually

```bash
docker build -t ds-docker-workflow .
```

This step is useful mainly to verify that the Dockerfile builds correctly.

---

## 12. Optional: VS Code Dev Containers

If you want to open the project directly inside Docker from VS Code, create a `.devcontainer` folder in the project root and add `devcontainer.json`.

Project structure:

```text
data-science-docker-workflow/
├── .devcontainer/
│   └── devcontainer.json
├── Dockerfile
├── environment.yml
├── requirements.txt
├── README.md
└── .gitignore
```

### `devcontainer.json`

```json
{
  "name": "ds-docker-workflow",
  "build": {
    "dockerfile": "../Dockerfile",
    "context": ".."
  },
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind",
  "workspaceFolder": "/workspace",
  "overrideCommand": true,
  "remoteUser": "mambauser",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.debugpy",
        "ms-toolsai.jupyter",
        "github.copilot",
        "github.copilot-chat"
      ],
      "settings": {
        "python.defaultInterpreterPath": "/opt/conda/envs/ds-env/bin/python"
      }
    }
  },
  "postCreateCommand": "micromamba run -n ds-env python -m ipykernel install --user --name ds-env --display-name \"Python (ds-env)\""
}
```

### Open in a Dev Container

In VS Code:

1. Install the **Dev Containers** extension
2. Press `Ctrl + Shift + P`
3. Run `Dev Containers: Rebuild and Reopen in Container`

### Important note

In this setup, Docker provides the environment and VS Code is the interface.

You generally do **not** need to work manually inside the container shell.

---

## 13. Important Limitation of Docker Desktop on Windows

In theory, Docker plus Dev Containers can provide a clean and reproducible workflow on Windows.

In practice, there is an important limitation:

* changing `environment.yml` often means rebuilding the image or container
* those rebuilds depend on Docker Desktop
* if Docker Desktop is unstable, hangs, or fails to start, the workflow becomes frustrating

This does **not** mean Docker is useless. It means that for notebook-heavy local development on Windows, it may be less practical than a direct Conda workflow.

So the practical recommendation is:

* use **Conda on Windows** as the default
* keep **Docker and Dev Containers** as an optional advanced workflow
* use Docker when reproducibility or containerization is specifically needed

---

## 14. Practical Recommendation

### Best default for local work on Windows

Use:

* `environment.yml`
* Conda environment
* VS Code interpreter and kernel selection

Main commands:

```bash
conda env create -f environment.yml
conda activate ds-env
python -m ipykernel install --user --name ds-env --display-name "Python (ds-env)"
```

When dependencies change:

```bash
conda env update -f environment.yml --prune
```

### Use Docker only if needed

Use Docker and Dev Containers when:

* you explicitly want a containerized workflow
* your team standardizes on containers
* you want stronger reproducibility beyond a Conda environment
* Docker Desktop is stable enough on your machine

---

## 15. Daily Workflow Summary

### Recommended daily workflow

1. Open the project folder in VS Code
2. Activate or use the existing Conda environment
3. Select the correct interpreter and notebook kernel
4. Work in notebooks or Python files
5. If dependencies change, update the environment
6. Commit and push changes

### Environment update workflow

1. Edit `environment.yml`
2. Run:

```bash
conda env update -f environment.yml --prune
```

3. Restart the notebook kernel if needed
4. Test imports
5. Commit changes

---

## 16. Future Improvements

Possible additions later:

* add formatting and linting tools such as `black` and `ruff`
* create a project template from this repository
* add a `src/` folder for a more structured Python project layout
* add Docker only for projects that benefit from containerization
* use remote Linux machines for heavier workloads
