class ApplicationController < ActionController::Base
  before_action :set_docker_info
  private

  def set_docker_info
    @info = Docker.info
  rescue Docker::Error::DockerError => e
    @error = "Failed to connect to Docker daemon #{e.message}"
  end
end
