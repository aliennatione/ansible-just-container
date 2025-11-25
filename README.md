# Ansible + Just Container Boilerplate

Questo repository è un boilerplate progettato per facilitare lo sviluppo e l'automazione con Ansible e Just, fornendo un ambiente containerizzato e una pipeline CI/CD pronta all'uso. Permette agli sviluppatori di gestire facilmente l'automazione dei server, la configurazione e il deployment in un ambiente coerente e riproducibile.

## Funzionalità Principali

*   **Ambiente Containerizzato**: Un `Dockerfile` pre-configurato per creare un'immagine Docker che include Python, Ansible, Just e `ansible-lint`, garantendo un ambiente di lavoro isolato e coerente.
*   **Task Automation con Just**: Un `Justfile` che definisce i task comuni per Ansible, come l'esecuzione di playbook (`play`), il controllo a secco (`check`), il linting dei playbook (`lint`) e l'installazione delle dipendenze di Ansible Galaxy (`deps`).
*   **Esempio di Struttura Ansible**: Include un inventario (`inventory/hosts`) e un playbook di esempio (`playbooks/site.yml`) per iniziare rapidamente.
*   **Integrazione Continua (CI/CD)**: Un workflow GitHub Actions (`ci-build-push.yml`) pre-configurato per:
    *   Eseguire il linting e i controlli dei playbook Ansible.
    *   Costruire automaticamente l'immagine Docker.
    *   Pubblicare l'immagine Docker nel GitHub Container Registry (GHCR) con tag `latest` e per lo SHA del commit.

## Tecnologie Utilizzate

*   **Ansible**: Motore di automazione open source per il provisioning del software, la gestione della configurazione e il deployment delle applicazioni.
*   **Just**: Un esecutore di comandi come `make`, ma più semplice e con una sintassi più moderna, ideale per definire e gestire script di progetto.
*   **Docker**: Piattaforma per lo sviluppo, la spedizione e l'esecuzione di applicazioni in container.
*   **Python**: Il linguaggio di programmazione su cui si basano Ansible e Just.
*   **GitHub Actions**: Strumento di automazione per il CI/CD integrato in GitHub.
*   **Ansible Lint**: Strumento per controllare i playbook Ansible per errori e violazioni delle best practice.

## Struttura del Progetto

```
ansible-just-container/  
├── .github/                       # Contiene i workflow di GitHub Actions
│   └── workflows/
│       └── ci-build-push.yml      # Workflow per CI, build e push dell'immagine Docker
├── Dockerfile                     # Definisce l'immagine Docker con Ansible e Just
├── Justfile                       # Definisce i task di automazione del progetto
├── inventory/                     # Directory per gli inventari Ansible
│   └── hosts                      # Inventario Ansible di esempio
├── playbooks/                     # Directory per i playbook Ansible
│   └── site.yml                   # Playbook Ansible di esempio
├── requirements.yml               # Definisce le dipendenze di Ansible Galaxy (ruoli e collection)
└── README.md                      # Questo file di documentazione
```

## Configurazione e Utilizzo

Per utilizzare questo boilerplate localmente, segui questi passaggi:

Si assume che tu abbia Docker e Node.js (anche se Node.js non è strettamente necessario per questo progetto specifico, è spesso un prerequisito in ambienti di sviluppo moderni) installati sul tuo sistema.

1.  **Clona il repository**:
    ```bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```
    (Sostituisci `your-username` e `your-repo-name` con i dettagli del tuo repository).

2.  **Costruisci l'immagine Docker**:
    Questo comando costruirà l'immagine Docker contenente Ansible e Just.
    ```bash
    docker build -t ansible-just .
    ```

3.  **Esegui un task di Just via Docker**:
    Dopo aver costruito l'immagine, puoi eseguire qualsiasi task definito nel `Justfile` all'interno del container. Il comando monta la directory di lavoro corrente (`$(pwd)`) nel container, permettendo al container di accedere ai tuoi playbook e inventari.
    ```bash
    docker run --rm -v "$(pwd)":/workspace -w /workspace ansible-just just play
    ```
    Per eseguire altri task, sostituisci `play` con il task desiderato (es. `check`, `lint`, `deps`).

4.  **Personalizzazione**:
    *   Modifica il `Justfile` per aggiungere nuovi task o personalizzare quelli esistenti (es. `deploy`, `test`, `sync`).
    *   Estendi `playbooks/site.yml` e `inventory/hosts` con la tua logica Ansible.
    *   Aggiungi ruoli e collection esterni in `requirements.yml` e installali con `just deps`.

## Deployment (Integrazione Continua e Pubblicazione Immagine)

Questo progetto utilizza GitHub Actions per automatizzare il processo di integrazione continua, compresa la pubblicazione dell'immagine Docker su GitHub Container Registry (GHCR).

Il workflow `ci-build-push.yml` si attiva su ogni `push` e `pull_request` al branch `main` ed esegue i seguenti passaggi:

1.  **Lint & Check Ansible**:
    *   Installa Python, Ansible, Just e `ansible-lint`.
    *   Esegue i task `just deps`, `just lint` e `just check` per validare i playbook e le dipendenze.
    *   Se questo job fallisce, i job successivi non verranno eseguiti.

2.  **Build Docker image and push**:
    *   Configura Docker Buildx.
    *   Esegue il login al GitHub Container Registry (GHCR) utilizzando le credenziali fornite da GitHub (`GITHUB_TOKEN`).
    *   Costruisce l'immagine Docker definita dal `Dockerfile` e la pubblica su GHCR. L'immagine viene taggata con `latest` e con lo SHA del commit, seguendo il formato `ghcr.io/<proprietario_repo>/<nome_repo>`.

**Configurazione per il Deployment**:

Per garantire che il workflow possa pubblicare l'immagine, il tuo repository GitHub deve avere le autorizzazioni corrette. Il file `ci-build-push.yml` include:

```yaml
permissions:
  contents: read
  packages: write
```

*   `contents: read`: Permette al workflow di leggere il codice del repository.
*   `packages: write`: Autorizza il workflow a scrivere (pubblicare) pacchetti, che include le immagini Docker su GHCR.

`GITHUB_TOKEN` è una variabile d'ambiente speciale fornita da GitHub Actions che non richiede configurazioni manuali (è un segreto temporaneo). Assicurati che le impostazioni del tuo repository consentano al `GITHUB_TOKEN` di scrivere pacchetti.

## Contributi

Siamo entusiasti di accogliere i contributi della comunità! Essendo un progetto open source, la collaborazione è fondamentale per migliorarlo.

Se hai idee, suggerimenti o trovi bug, non esitare a:

*   **Segnalare un bug**: Apri un'issue descrivendo il problema riscontrato, includendo i passaggi per riprodurlo se possibile.
*   **Suggerire una funzionalità**: Apri un'issue per proporre nuove idee o miglioramenti.
*   **Inviare una Pull Request**: Se hai già implementato una soluzione o una nuova funzionalità, invia una pull request! Assicurati che il tuo codice segua le best practice e includi test se pertinenti.

Ogni contributo è apprezzato!

## Licenza

Questo progetto è rilasciato sotto licenza MIT. Per maggiori dettagli, consulta il file `LICENSE` nel repository.

```
MIT License

Copyright (c) [Anno] [Nome del Titolare del Copyright]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```