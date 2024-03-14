# AzerothContainers

A portainer like application for managing docker containers with a simple UI.
> [!WARNING]  
> The current Dockerfile uses root permissions to connect to the docker daemon. This is not secure and will be changed in a future period.

## Roadmap

### Security
- [X] Remove root access for group access method
- [X] Add authentication

### Containers
- [X] Can see all containers
- [X] Can see specific container
- [] Can start container TODO: Started coding start container. Need to add to index form.
- [] Can stop container
- [] Can restart container
- [] Can remove container
- [] Can see logs of container
- [] Can see stats of container
- [] Can see exec into container
- [] Can see inspect of container
- [] Can create a container (with options)

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
`rails s` to start server
`./bin/dev` to start server in build mode for tailwind
