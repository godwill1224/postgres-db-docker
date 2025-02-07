# PostgreSQL & pgAdmin Docker Setup

This project provides a Docker Compose configuration to run a PostgreSQL database and pgAdmin in a containerized environment. The setup includes a `Makefile` for managing the lifecycle of the PostgreSQL container using simple commands.

## Prerequisites
Ensure you have the following installed on your system:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Make](https://www.gnu.org/software/make/)

## Configuration
The PostgreSQL and pgAdmin services are defined in the `docker-compose.yml` file with the following settings:

### PostgreSQL (`db`)
- **Image**: `postgres:16`
- **Container Name**: `postgres-db`
- **Environment Variables** (stored in `.env` file):
  - `POSTGRES_USER`: Username for PostgreSQL authentication.
  - `POSTGRES_PASSWORD`: Password for PostgreSQL authentication.
  - `POSTGRES_DB`: Name of the database to be created.
  - `POSTGRES_PORT`: Port for PostgreSQL.
- **Ports**: Exposes port `5432` (configurable via `.env`).
- **Volumes**: Data persistence is managed using a Docker volume `postgres_data`.
- **Networks**: The service is attached to a custom Docker network `mynetwork`.
- **Health Check**: The database service is monitored using `pg_isready` to ensure readiness before dependent services start.

### pgAdmin (`pgadmin`)
- **Image**: `dpage/pgadmin4`
- **Container Name**: `pgadmin`
- **Environment Variables** (stored in `.env` file):
  - `PGADMIN_DEFAULT_EMAIL`: Admin email for pgAdmin login.
  - `PGADMIN_DEFAULT_PASSWORD`: Admin password for pgAdmin login.
  - `PGADMIN_PORT`: Port for accessing pgAdmin.
- **Ports**: Exposes port `5050` (configurable via `.env`).
- **Depends on**: `db`, and only starts when PostgreSQL is healthy.

## Files Overview
### `.env`
Contains environment variables for PostgreSQL and pgAdmin configurations.

### `docker-compose.yml`
Defines the PostgreSQL and pgAdmin services, including networking, volumes, and health checks.

### `Makefile`
A set of commands to manage the Docker Compose lifecycle efficiently.

### `.gitignore`
Ensures sensitive files, temporary files, and Docker artifacts are not committed to version control.

## Usage

### Setting up environment variables
Copy the `.env.example` file to `.env` and update it with your credentials:
```sh
cp .env.example .env
```

### Starting the Services
To start the PostgreSQL and pgAdmin containers in detached mode, run:
```sh
make up
```

### Rebuilding the Containers
If you make changes to the configuration and need to rebuild the containers, use:
```sh
make rebuild
```

### Stopping and Rebuilding the Containers
To stop the containers and rebuild them:
```sh
make zap
```

### Stopping, Removing Volumes, and Rebuilding the Containers
If you need to remove all volumes and start fresh, use:
```sh
make .zap
```
**Warning**: This will delete all stored data.

### Stopping and Removing the Containers
To stop and remove the containers without deleting volumes, run:
```sh
make down
```

### Removing Volumes
To remove all volumes associated with the containers:
```sh
make volumes
```
**Warning**: This permanently deletes all stored database data.

## Accessing pgAdmin
- **URL**: `http://localhost:5050` (or as configured in `.env`)
- **Login**: Use the email specified in `PGADMIN_DEFAULT_EMAIL`
- **Password**: Use the password specified in `PGADMIN_DEFAULT_PASSWORD`

## Connecting to PostgreSQL
You can connect to the PostgreSQL instance using any PostgreSQL client. The default connection parameters are:

- **Host**: `localhost`
- **Port**: `5432` (or as configured in `.env`)
- **Username**: `postgres_username`
- **Password**: `postgres_password`
- **Database**: `postgres_db_name`

To connect via the command line, use:
```sh
docker exec -it postgres-db psql -U postgres_username -d postgres_db_name
```

## Troubleshooting
- Ensure Docker is running before executing the commands.
- If you face permission issues, try running commands with `sudo`.
- If the database is not persisting data, ensure the `postgres_data` volume is correctly mounted.
- pgAdmin may not start if PostgreSQL is not healthy. Ensure PostgreSQL is running before starting pgAdmin.

## License
This setup is open-source and free to use for any project.

