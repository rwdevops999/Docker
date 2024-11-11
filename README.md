# Docker Compose File

For running multi-container applications.

## version (OPTIONAL)

Only for backward compatibility.

## name

Project name
The value is set also as COMPOSE_PROJECT_NAME for further use.

## services

Map where the keys are the service names.

```docker-compose.yml
services:
    web:
        ...
    db:
        ...
```

### servicename:

#### image

The image to start the container from.

#### container-name:

A custom container name.

#### command

Override the container default command (CMD).

#### ports

Port mapping between the machone and the container. Allows external access to the service from outside the container.
(HOST:CONTAINER).

#### volumes

Mounts host paths (or named volumes) that are accessible by the service container.
(HOST VOLUME:CONTAINER PATH).

#### restart

The policy on container termination.

> > > always: always restart the container until it is removed.

#### environment

Defines environment variables set in the container.

#### labels

Metadata for the container.

```docker-compose.yml
- "key=value"

e.g.

- "traefik.enable=true"
```

#### healthcheck

Declares a check that's run to determine whether the container is healthy.

#### depends_on

Controls the order of service startup (and shutdown).
Useful if services are closely coupled.

## volumes

Persistent data store (named volumes) that can be used by a service.

# TUT-O-PEDIA

## proxy (traefik)

HTTP Reverse Proxy for integrating components (services). A reverse proxy is a server, app, or cloud service that sits in front of one or more services to intercept and inspect incoming client requests before forwarding them to the service and subsequently returning the service's response to the client.

Traefik Dashboard: http://localhost:8080

Traefik inspects the services to set-up the right configuration.

## postgres

Object-Relational Database Management System (ORDBMS). Database Server;

### postgres Environment Variables

- POSTGRES_PASSWORD (required) sets the superuser (defined by POSTGRES_USER) password.
- POSTGRES_USER (optional, default: postgres) becomes the superuser.
- POSTGRES_DB (optional, default: postgres) the name of the default database.
- POSTGRES_HOST_AUTH_METHOD (optional) controls auth-method for all databases and all users.
  - trust: allow the connection unconditionally. Allows anyone that can connect to log in without need of password. PostgreSQL assumes that anyone who can connect to the server is authorized to access the database with whatever database user name they specify.
  - password: the client must provide an unencrypted password for authentication.

### volume

A named volume to /var/lib/postgresql/data

```docker-compose.yml
postgres:
    volumes:
      - postgres:/var/lib/postgresql/data

volumes:
  postgres:
```

### port

Postgres works on port 5432.

### healtcheck

healthcheck:
test: ["CMD-SHELL", "pg_isready", "-d", "db_prod"]
// Command pg_isready -d db_prod -> specifies the name of the database to connect to
interval: 10s
// The interval between the health checks (in seconds)
timeout: 5s
// The maximum number of seconds to wait when attempting connection before returning that the server is not responding
retries: 5
// THe max number of retries before giving up.
start_period: 30s
// Provides initialization time for containers that need time to bootstrap.

```docker-compose.yml
depends_on:
    postgres:
        condition: service_healthy
```

### traefik

(when traefik and postgres are in same docker compose file)

labels:
// enable traefik on Postgres directly

- "traefik.enable=true"

  // set entrypoint rule to TCP \_ (for TCP (or all TLS connections) use HostSNI= Host Server Name Indication)

- "traefik.tcp.routers.postgres.rule=HostSNI(`_`)"

  // set routing using TCP

- "traefik.tcp.routers.postgres.entrypoints=tcp"

  // Set routing to postgres

- "traefik.tcp.routers.postgres.service=postgres"

  // Redirect everything traefik receives on port 5432 to Postgres at port 5432

- "traefik.tcp.services.postgres.loadbalancer.server.port=5432"

## liquibase

Database Schema Change Management solution.

## backend

Tut-O-Pedia backend API based on SpringBoot - Rest

## frontend

Tut-O-Pedia frontend application based on React.
