FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
ARG WOW_TOOLS_VERSION=main

RUN apt-get -f install git
RUN git clone --recursive --branch ${WOW_TOOLS_VERSION} https://github.com/Marlamin/wow.tools.local app
WORKDIR /app

# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -r linux-x64 --self-contained -f net9.0 -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0

RUN apt-get update 
RUN apt-get -f install libicu72 libssl3

EXPOSE 8080

WORKDIR /app
COPY --from=build-env /app/out .
RUN mkdir /app/cache
ENTRYPOINT ["./wow.tools.local"]
