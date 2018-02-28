# mongo-backup-alpine

[![](https://images.microbadger.com/badges/image/megahertz/mongo-backup-alpine.svg)](https://microbadger.com/images/megahertz/mongo-backup-alpine "Get your own image badge on microbadger.com")

Simple MongoDB backup service in Docker built on
[alpine image](https://hub.docker.com/_/alpine/)
and [Supercronic](https://github.com/aptible/supercronic)

## Usage

### Run the backup service
```sh
docker run -e MONGO_URL=mongodb://host \
  -v /backup:/data/backup megahertz/mongo-backup-alpine
```

#### Volumes
The image writes backups to /data/backup, so you need to mount this
path on host machine to store backups.

#### Environment variables:

Name            | Default              | Description
----------------|----------------------|------------
MONGO_URL       | (required)           | Connection string to MongoDB
BACKUP_LIFETIME | 10                   | Delete backups older than N days
BACKUP_PATTERN  | "+%Y-%m-%d-%H-%M-%S" | Pattern for backup name
BACKUP_SCHEDULE | "0 4 * * *"          | How often to make backup, crontab format

By default, the service makes backup each day at 4am. If you're not
familar with crontab, you can
[check the examples](https://crontab.guru/examples.html)


### Run using Compose

```yaml
version: "3"
services:
  mongo:
    image: mvertes/alpine-mongo:3.4.7-0
    networks:
      - mynet
    restart: always
    volumes:
      - ./db:/data/db

  mongo-backup:
    image: megahertz/mongo-backup-alpine:latest
    depends_on:
      - mongo
    environment:
      - MONGO_URL=mongodb://mongo
    networks:
      - mynet
    restart: always
    volumes:
      - ./backup:/data/backup

networks:
  mynet:

```

## Scripts

### Make backup manually

`backup [mongodump args]`

Example:

```sh
docker run -e MONGO_URL=mongodb://host \
  -v /backup:/data/backup megahertz/mongo-backup-alpine backup
```

### Get list of existing backups

`list`

Example:

```sh
docker run -v /backup:/data/backup megahertz/mongo-backup-alpine list
```

### Restore from backup

`restore BACKUP_FILE [mongorestore args]`

Example:

```sh
docker run -e MONGO_URL=mongodb://host \
  -v /backup:/data/backup megahertz/mongo-backup-alpine \
  restore 2018-02-01-04-00-00.gz --drop
```

## License

Licensed under MIT.
