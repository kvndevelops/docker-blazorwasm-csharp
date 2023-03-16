FROM alpine:3.17 as build

RUN mkdir -p /home/docker-blazor
WORKDIR /home/docker-blazor

RUN apk add dotnet7-sdk

RUN apk add aspnetcore7-runtime

COPY . .

RUN dotnet restore DockerTest.csproj

RUN dotnet build DockerTest.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish DockerTest.csproj -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
