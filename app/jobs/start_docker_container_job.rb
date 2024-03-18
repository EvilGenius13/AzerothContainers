class StartDockerContainerJob < ApplicationJob
  queue_as :default

  def perform(docker_container_id)
    docker_container = Docker::Container.get(docker_container_id)
    docker_container.start
  rescue Docker::Error::DockerError => e
    puts "Failed to start container: #{e.message}"
  end
end
