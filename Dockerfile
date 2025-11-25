FROM python:3.12-slim

# Ambiente non interattivo per apt
ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/appuser

# Installazione dipendenze di sistema (root)
RUN apt-get update && apt-get install -y --no-install-recommends \
        openssh-client \
        git \
        ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crea utente
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /home/appuser

USER appuser
WORKDIR /home/appuser

# Crea venv
RUN python -m venv /home/appuser/venv
ENV PATH="/home/appuser/venv/bin:$PATH"

# Copia i requirements e installa le dipendenze nel venv
# COPY prima requirements.txt per sfruttare cache
COPY --chown=appuser:appuser requirements.txt /home/appuser/requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /home/appuser/requirements.txt

# Imposta la directory di lavoro per il codice
WORKDIR /workspace

# Copia il resto del progetto
COPY --chown=appuser:appuser . /workspace

# Copia entrypoint
COPY --chown=appuser:appuser entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
