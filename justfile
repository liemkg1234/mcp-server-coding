set dotenv-load
export PROJECT_NAME := env("PROJECT_NAME", "mcp-server-coding")
export ENV := env("ENV", "dev")
## Docker Environment
DOCKER_NETWORK_NAME := "$PROJECT_NAME-$ENV-net"

# Export env.docker
export-env-docker:
    rm -rf .env.docker
    echo "# Networks" >> .env.docker
    echo "DOCKER_NETWORK_NAME={{DOCKER_NETWORK_NAME}}" >> .env.docker

# Export to .env
environment: export-env-docker
    cp .env.example .env


stop: export-env-docker
    docker compose --env-file .env.docker --env-file .env \
      -p {{PROJECT_NAME}}-{{ENV}} \
      -f docker-compose.yml \
      down

start: stop
    @echo "Starting PROJECT '{{PROJECT_NAME}}' with ENVIRONMENT: {{ENV}}"
    docker compose --env-file .env.docker --env-file .env \
      -p {{PROJECT_NAME}}-{{ENV}} \
      -f docker-compose.yml \
      up -d

## Helper
help:
    @echo "just environment     Setup .env file"
    @echo "just start           Start servers with docker"
    @echo "just stop            Stop servers"