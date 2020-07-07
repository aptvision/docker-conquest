# docker-conquest
Docker container implementing version 1.5.0 of the [ConQuest DICOM server]. 

[ConQuest DICOM server]: <https://ingenium.home.xs4all.nl/dicom.html>

## About
The ConQuest DICOM Server in a docker image. This image supports the built-in sqlite database and 
using an external postgres database. MariaDB is also possible but not yet tested with this image.

## Running
To run the Docker image with the built-in sqlite db, simply run:
```sh
$ sudo docker run -p 5678:5678 -p 80:80 -v /opt/conquest/data/ aptvision/conquest-server
```
Note that this will bind ports 5678 and 80 in the Docker container to the same ports on the host.  Change these if you want them bound elsewhere.

The ConQuest web interface is then accessible by opening a web browser and navigating to `http://localhost`.

### Docker compose

Alternatively, use docker-compose. See the [compose-examples](compose-examples) directory for examples. To run
conquest using postgres for example:

    docker-compose --file compose-examples/docker-compose-postgres.yml --project-name conquest up 

### Ports
The following ports on the container are exposed for you to bind to: 
  - Port 5678 - used for DICOM send/query/receive.
  - Port 80 - used for http.

## Databases

Conquest can use a variety of databases. Use the `DB_TYPE` env var to change this. Note that if you
override this then you might also need to set some more variables to configure the connection.

### PostgreSQL env vars
    
    DB_TYPE: "postgres"
    POSTGRES_HOST: "postgres"
    POSTGRES_SERVER: "conquest"
    POSTGRES_USERNAME: "conquest"
    POSTGRES_PASSWORD: mysecretpassword

#### Built-in SQLite database

Mo env vars required to use the built-in SQLite database, this is used when no `DB_TYPE` is specified.
    
#### MariaDB

MariaDB is not tested, please submit a PR and it will be gladly accepted.

# Licence
MIT Licence for Dockerfile.
ConQuest DICOM server is licensed separately (see [LICENSE] file).

[LICENSE]: <https://github.com/aptvision/docker-conquest/blob/master/LICENSE>

# Issues
Please report any issues and I'll get to them ASAP.


