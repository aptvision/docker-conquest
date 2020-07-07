# docker-conquest
Docker container implementing version 1.5.0 of the [ConQuest DICOM server]. 

[ConQuest DICOM server]: <https://ingenium.home.xs4all.nl/dicom.html>

## About
The ConQuest DICOM Server in a docker image.

## Installation
### Option 1: Download from Docker Hub
All updates to this repository are automatically built on the associated Docker Hub page: [conquest-server]

[conquest-server]: <https://hub.docker.com/r/aptvision/conquest-server/>

To pull this directly from Docker Hub, simply run:
```sh
$ sudo docker pull aptvision/conquest-server
```


### Option 2: Build locally using Docker
If you want to build from the Dockerfile, clone the [docker-conquest github repository] to your local machine, open a terminal in that folder and type:
```sh
$ sudo docker build -t conquest-server .
```

[docker-conquest github repository]: <https://github.com/aptvision/conquest-server>

## Databases

Conquest can use a variety of databases. Use the `DB_TYPE` env var to change this. Note that if you
override this then you might also need to set some more variables to configure the connection.

### PostgreSQL env vars
    
    DB_TYPE: "postgres"
    POSTGRES_SERVER: "postgres"
    POSTGRES_USERNAME: "conquest"
    POSTGRES_PASSWORD: mysecretpassword

#### Preconfigured database

    no env vars required, this is default

## Running
To run the Docker image, simply run:
```sh
$ sudo docker run -p 5678:5678 -p 80:80 conquest-server
```
Note that this will bind ports 5678 and 80 in the Docker container to the same ports on the host.  Change these if you want them bound elsewhere.

The ConQuest web interface is then accessible by opening a web browser and navigating to `http://localhost`.

### Docker compose

Alternatively, see [docker-compose.yml] for an example docker-compose file (using postgres).

### Ports
The following ports on the container are exposed for you to bind to: 
  - Port 5678 - used for DICOM send/query/receive.
  - Port 80 - used for http.

# Licence
MIT Licence for Dockerfile.
ConQuest DICOM server is licensed separately (see [LICENSE] file).

[LICENSE]: <https://github.com/aptvision/docker-conquest/blob/master/LICENSE>

# Issues
Please report any issues and I'll get to them ASAP.


