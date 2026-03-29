FROM mambaorg/micromamba:1.5.10

WORKDIR /workspace

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml requirements.txt ./

RUN micromamba create -y -f environment.yml && \
    micromamba clean --all --yes

CMD ["sleep", "infinity"]