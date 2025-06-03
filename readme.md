# Local LLM Project with Ollama

This project lets you interact with Large Language Models (LLMs) locally on your machine, using [Ollama](https://ollama.com/) to run the models **for test purpose only**.
It provides 3 ways to interact with the selected LLMs:

1. using OpenWebUi (a user friendly interface https://openwebui.com/ )
2. prompting the LLMS through terminal
3. using HTTP requests.

The project is configured to be managed via Docker Compose, and includes automation for downloading two LLM models (deepseek-r1:1.5b and tinyllama) on startup.

## Project Structure

```
.
├── docker-compose.yml
├── ollama.Dockerfile
├── init_models.sh
└── README.md
```

## Software Used and Versions

- **Docker Engine:** Version 20.10.x or higher (required for Docker Compose v2).
- **Docker Compose:** Version 2.x.x or higher (integrated with recent Docker Desktop versions).
- **Ollama:** The version used can be determined by the `OLLAMA_DOCKER_TAG` environment variable (defaults to `latest`).
- **Open WebUI**: Utilizes the ghcr.io/open-webui/open-webui:main Docker image.

## Performance consideration

This project does not take into account performance which could be enhanced using NVIDIA graphics card. The docker-compose file will then have to be updated accordingly.

## Downloading Models

Models to be downloaded can be selected on https://ollama.com/library

To specify which models to download, modify the MODELS_TO_PULL variable (a list) in the init_models.sh file

Example:
`MODELS_TO_PULL=("deepseek-r1:1.5b" "tinyllama")`

## Steps to launch the project

1.  \*\* Ensure `init_models.sh` has the correct permissions.

    ```bash
    chmod +x init_models.sh
    ```

2.  **Launch the project:**

    ```bash
    docker compose up --build -d
    ```

    The build process might take some time, especially the first time.

## Interacting with LLMS

Once the containers are running :

- **OpenWebUi** : access the openWebUi interface in your browser at [localhost:3000](http://localhost:3000). Register and select a LLM.

- **Terminal** : run the commands below.

1. Enter into Ollama container's shell

   ```bash
       docker exec -it <ollama container id> bash
   ```

2. Launch Ollama indicating the name of the LLM to be used, then start prompting

   ```bash
       ollama run <name of the LLM>
   ```

- **Http request** : Ollama is available on your machine at [localhost:11434](http://localhost:11434/). API documentation can be found here: https://www.llamafactory.cn/ollama-docs/en/api.html

## Stopping and Cleaning Up the Project

```bash
docker-compose down
```

## AI

This project (files and documentation) was created with the help of Gemini AI (Google).
