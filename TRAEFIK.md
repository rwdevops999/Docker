# TRAEFIK

T is an application proxy which receives requests from clients and identifies which components (services) are responsible for handling those requests and routes the requests to them. It automatically discovers the correct configuration for handling the requests. The components are label-based. Each service has a set of labels attached. T is the door to the complete application. It intercepts and routes each request. T is the only accessible container from the outside.

We use in docker-compose a static configuration (in docker-compose.yml). Attach labels to the services and let T do the rest.

## Provider

The '--providers.docker' option enables the docker provider

```docker-compose.yml
// USE DOCKER AS A PROVIDER
--providers.docker=true

// WORK WITH LABELS
services:
  my-container:
    # ...
    labels:
        - traefik.http.routers.my-container.rule=Host(`example.com`)
```

## Labels

// Attaching labels to containers
services:
my-container: # ...
labels: - traefik.http.routers.my-container.rule=Host(`example.com`)

// Forward requests for http://example.com to http://<private IP of container>:12345
services:
my-container: # ...
labels: - traefik.http.routers.my-container.rule=Host(`example.com`) # Tell Traefik to use the port 12345 to connect to `my-container` - traefik.http.services.my-service.loadbalancer.server.port=12345

By default, Traefik uses the first exposed port of a container.
Setting the label traefik.http.services.xxx.loadbalancer.server.port overrides that behavior.

## Entrypoints

Are the network entrypoints into T. They define the port that receives the packets and listen for TCP OR UDP.
Entrypoints are in the most basic form just a port number.

## Routers

A router is in charge of routing incoming requests to the service that handles them. The router analyses the request.

## docker setup

```docker-compose.yml
reverse-proxy:
    image: traefik:v2.11
    # Tells Traefik to listen to docker
    command: --providers.docker
    ports:
      # The HTTP port
      - "80:80"
      # The Web UI (enabled by --api.insecure=true)
      - "8080:8080"
    volumes:
      # So that Traefik can listen to the Docker events
      - /var/run/docker.sock:/var/run/docker.sock
```

## dashboards

See T API raw data
http://localhost:8080/api/rawdata

WebUI
http://localhost:8080

## connecting a service

```docker-compose.yaml
services:

  ...

  whoami:
    # A container that exposes an API
    image: XXX
    labels:
      - "traefik.http.routers.whoami.rule=Host(`...`)"
```
