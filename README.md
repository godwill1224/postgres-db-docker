# PostgreSQL Docker Setup

This project provides a Docker Compose configuration to run a PostgreSQL database in a containerized environment. The setup includes a `Makefile` for managing the lifecycle of the PostgreSQL container using simple commands.

## Prerequisites
Ensure you have the following installed on your system:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Make](https://www.gnu.org/software/make/)

## Configuration
The PostgreSQL service is defined in the `docker-compose.yml` file with the following settings:

- **Image**: `postgres:16`
- **Container Name**: `postgres-db`
- **Environment Variables**:
  - `POSTGRES_USER`: Username for PostgreSQL authentication.
  - `POSTGRES_PASSWORD`: Password for PostgreSQL authentication.
  - `POSTGRES_DB`: Name of the database to be created.
- **Ports**: Exposes port `5432` to allow external connections.
- **Volumes**: Data persistence is managed using a Docker volume `postgres_data`.
- **Networks**: The service is attached to a custom Docker network `mynetwork`.

## Files Overview
### `docker-compose.yml`
Defines the PostgreSQL service, including networking, volumes, and environment variables.

### `Makefile`
A set of commands to manage the Docker Compose lifecycle efficiently.

## Usage

### Starting the PostgreSQL Container
To start the PostgreSQL container in detached mode, run:
```sh
make up
```

### Rebuilding the Container
If you make changes to the configuration and need to rebuild the container, use:
```sh
make rebuild
```
This command stops the running container, rebuilds the image, and starts it again.

### Stopping and Rebuilding the Container
To stop the container and rebuild it:
```sh
make zap
```

### Stopping, Removing Volumes, and Rebuilding the Container
If you need to remove all volumes and start fresh, use:
```sh
make .zap
```
**Warning**: This will delete all stored data.

### Stopping and Removing the Container
To stop and remove the container without deleting volumes, run:
```sh
make down
```

### Removing Volumes
To remove all volumes associated with the container:
```sh
make volumes
```
**Warning**: This permanently deletes all stored database data.

## Connecting to PostgreSQL
You can connect to the PostgreSQL instance using any PostgreSQL client. The default connection parameters are:

- **Host**: `localhost`
- **Port**: `5432`
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

## License
This setup is open-source and free to use for any project.

