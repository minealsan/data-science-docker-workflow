FROM mambaorg/micromamba:1.5.10

WORKDIR /workspace

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml requirements.txt ./

RUN micromamba create -y -f environment.yml && \
    micromamba clean --all --yes

SHELL ["micromamba", "run", "-n", "ds-env", "/bin/bash", "-c"]

COPY --chown=$MAMBA_USER:$MAMBA_USER . /workspace
 
CMD ["bash"]