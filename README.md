# mongo-backup-alpine

Simple MongoDB backup service in Docker

## Usage
```sh
docker run -e MONGO_URL=mongodb://host -v /backup:/data/backup megahertz/mongo-backup-alpine
```
