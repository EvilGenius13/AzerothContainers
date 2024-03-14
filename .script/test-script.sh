#!/bin/bash

# Check if Docker is installed
# if ! command -v docker &> /dev/null; then
#     echo "Docker could not be found. Please install Docker first."
#     exit 1
# fi

# Check if the user is in the Docker group and add them if not
if ! id -nG "$USER" | grep -qw "docker"; then
    echo "Adding the current user to the Docker group. This may require your password."
    sudo usermod -aG docker $USER
    echo "Please log out and log back in for the changes to take effect, then re-run this script."
    exit 1
fi

# Pull the Docker image (replace 'your_rails_app_image' with your actual image name)
docker pull evilgenius13/azerothcontainers:dev || { echo "Failed to pull Docker image"; exit 1; }

# Run the Docker container with the necessary parameters
docker run -d -p 3000:3000 \
    -e RAILS_ENV=development \
    -e INSIDE_DOCKER=true \
    -v /var/run/docker.sock:/var/run/docker.sock \
    evilgenius13/azerothcontainers:dev || { echo "Failed to run Docker container"; exit 1; }

echo "Your Rails application should now be running and accessible at http://localhost:3000"
