# Demo: Azure Functions in a Container App
This demonstration presents a simple product catalog service that's deployable to an Azure Container App resource. The build artifact is hosted in GitHub Packages.

[![Build Dockerfile](https://github.com/anttikes/azure-demo/actions/workflows/build-image.yml/badge.svg?branch=main)](https://github.com/anttikes/azure-demo/actions/workflows/build-image.yml)

## Technology stack
This demo uses the following technologies:
- Docker & Docker Compose
- SQL Server on Linux
- .NET Core 6.0
- Azure Functions (Isolated worker)
- Azure Functions HTTP triggers
- Entity Framewok Core (with Migrations and Compiled Models)
- Bicep templates

## Running the demo
After installing the prerequirements, follow these instructions:
1. Checkout the source
2. Open the folder in VS Code
3. Install the recommended extensions
4. Copy the connection string from docker-compose.yml, replacing server name with `localhost`
5. Open a shell prompt, and
   - Set the SQL_CONNECTION_STRING environment variable's value to the connection string from step #4
   - Issue `docker compose --project-directory "src" up -d`
6. You can now reach the API at `http://localhost:32741/api/products` endpoint.
   - Copy the function key from `host_secrets.json` and supply the value either via `code` query parameter or via `x-functions-key` header
7. Issue `docker compose --project-directory "src" stop` to stop the containers
