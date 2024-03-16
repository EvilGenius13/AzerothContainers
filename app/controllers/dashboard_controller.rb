class DashboardController < ApplicationController
  def index
    @info = Docker.info
  rescue Docker::Error::DockerError => e
    @error = "Failed to connect to Docker daemon #{e.message}"
  end
end
