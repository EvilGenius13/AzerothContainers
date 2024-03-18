# AzerothContainers

A portainer like application for managing docker containers with a simple UI.
> [!WARNING]  
> The current Dockerfile uses root permissions to connect to the docker daemon. This is not secure and will be changed in a future period.

## Roadmap

### Security
- [] Remove root access for group access method
- [] Add authentication

### Containers
- [X] Can see all containers
- [X] Can see specific container
- [X] Can start container
- [X] Can stop container
- [] Can restart container
- [] Can pause container
- [] Can unpause container
- [] Can remove container
- [X] Can see logs of container
- [X] Can see stats of container (CPU, Memory, Network, Disk, IO) - Currently only a snapshot. See (Container Stats Monitoring)
- [] Can see exec into container
- [] Can see inspect of container
- [X] Can create a container TODO: Need to test latest container with a fresh pull from dockerhub with noticeable change.
- [] Add UDP and TCP port mapping options.
- [] TODO: When running docker run -p 3000 it automatically creates an external port in the 5xxxx range. Should mimic the same behaviour.


### Container Stats Monitoring
- [] Set up the following as a stream
  - [] Can see CPU usage
  - [] Can see Memory usage
  - [] Can see Network usage
  - [] Can see Disk usage
  - [] Can see IO usage

### Images
- [] Can see all images
- [] Can see specific image
- [] Can pull image
- [] Can remove image

### Networks
- [] Can see all networks

### Volumes
- [] Can see all volumes

### Compose
Mid term goal

### Swarm
Long term goal

### Stacks
Long term goal

### Kubernetes
Long term goal

## Starting

### Locally
`bundle install` to install dependencies
`rails s` to start server
`./bin/dev` to start server in build mode for tailwind

### Locally via Docker
`docker build -t azeroth_containers .` to build the docker image
`docker run -p 3000:3000 azeroth_containers` to run the docker image

### Latest build from Dockerhub (Dev)
`docker run -p 3000:3000 evilgenius13/azerothcontainers:dev`
