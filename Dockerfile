# Stage 1 
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /

# Restore
COPY ["./learnwithjon-docker.csproj" "dockerize-dotnet-1/"]
RUN dotnet restore 'dockerize-dotnet-1/learnwithjon-docker.csproj'

# Build
COPY ["." "dockerize-dotnet-1/"]
RUN dotnet build 'dockerize-dotnet-1/learnwithjon-docker.csproj' -c Release -o /app/build

# Stage 2 : Publish
FROM build AS publish
RUN dotnet publish 'dockerize-dotnet-1/learnwithjon-docker.csproj' -c Release -o /app/publish

# Stage 3 : RUN
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=3001
EXPOSE 3001
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet","learnwithjon.dll" ]
