FROM mcr.microsoft.com/dotnet/sdk:6.0 AS installer-env
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"
WORKDIR "/src"
COPY ["Products.API/", "."]
RUN dotnet ef dbcontext optimize --output-dir "CompiledModels"
RUN mkdir -p /publish
RUN dotnet publish "Products.API.csproj" -c Release -o /publish

FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated6.0
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true
COPY --from=installer-env ["/publish", "/home/site/wwwroot"]
COPY ["Products.API/host_secrets.json", "/azure-functions-host/Secrets/host.json"]
