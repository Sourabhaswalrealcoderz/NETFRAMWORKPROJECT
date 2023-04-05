//FROM mcr.microsoft.com/dotnet/core/sdk:6.0 AS build-env
//WORKDIR /app

//COPY *.csproj ./
//RUN dotnet restore

//COPY . ./
//RUN dotnet publish -c Release -o out

//FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
//WORKDIR /app
//COPY --from=build-env /app/out .
//ENTRYPOINT [ "dotnet", "AspNetCoreWebAPI.dll"]


# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
