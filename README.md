# docker-conquest
Docker container implementing version 1.5.0 of the [ConQuest DICOM server]. 

[ConQuest DICOM server]: <https://ingenium.home.xs4all.nl/dicom.html>

## About
The ConQuest DICOM Server in a docker image.

## Installation
### Option 1: Download from Docker Hub
All updates to this repository are automatically built on the associated Docker Hub page: [docker-conquest]

[docker-conquest]: <https://hub.docker.com/r/docker-conquest/docker-conquest/>

To pull this directly from Docker Hub, simply run:
```sh
$ sudo docker pull aptvision/docker-conquest
```


### Option 2: Build locally using Docker
If you want to build from the Dockerfile, clone the [docker-conquest github repository] to your local machine, open a terminal in that folder and type:
```sh
$ sudo docker build -t docker-conquest .
```

[docker-conquest github repository]: <https://github.com/wavedrift/docker-conquest>

## Running
To run the Docker image, simply run:
```sh
$ sudo docker run -p 5678:5678 -p 80:80 docker-conquest
```
Note that this will bind ports 5678 and 80 in the Docker container to the same ports on the host.  Change these if you want them bound elsewhere.

The ConQuest web interface is then accessible by opening a web browser and navigating to `http://localhost/cgi-bin/dgate`.

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


