require 'docker'

class ContainersController < ApplicationController
  include ContainersHelper
  before_action :set_docker_url
  before_action :set_container, only: %i[ show edit update destroy logs start stop stats ]

  # GET /containers or /containers.json
  def index
    @containers = Docker::Container.all(all: true)
  rescue Docker::Error::DockerError => e
    @error = "Failed to connect to Docker daemon #{e.message}"
  end

  # GET /containers/1 or /containers/1.json
  def show
  end

  # Start container
  def start
    @container.start
    redirect_to containers_url, notice: "Container was succesfully started."
  rescue Docker::Error::DockerError => e
    redirect_to containers_url, alert: "Failed to start container: #{e.message}"
  end

  # Stop container
  def stop
    @container.stop
    redirect_to containers_url, notice: "Container was successfully stopped."
  rescue Docker::Error::DockerError => e
    redirect_to containers_url, alert: "Failed to stop container: #{e.message}"
  end

  # Container logs
  def logs
    log_entries = []
    include_stderr = params[:log_level] == 'advanced'
    
    @container.streaming_logs(stdout: true, stderr: include_stderr) do |stream, chunk|
      prefix = stream == :stdout ? "stdout" : "stderr"
      log_entries << "#{prefix}: #{chunk}" if include_stderr || stream == :stdout
    end

    @logs = log_entries
  end

  # Container stats (Non-Streaming)
  def stats
    stats_data = @container.stats(api: {stream: false})
    @container_stats = stats_data
  end

  # GET /containers/new
  def new
    @container_form = ContainerForm.new
    Rails.logger.debug "@container_form: #{@container_form.inspect}"
  end

  # GET /containers/1/edit
  def edit
  end

  # POST /containers or /containers.json
  def create
    @container_form = ContainerForm.new(container_params)
  
    if @container_form.valid?
      docker_params = create_container_params(params)
  
      always_pull = ActiveModel::Type::Boolean.new.cast(@container_form.always_pull)
      if always_pull || !image_exists_locally?(docker_params['Image'])
        unless pull_image(docker_params['Image'])
          flash.now[:alert] = "Failed to pull the specified image. Please check the image name and try again."
          render :new, status: :unprocessable_entity and return
        end
      end

      @docker_container = Docker::Container.create(docker_params)

      if @docker_container.id.present?
        StartDockerContainerJob.perform_later(@docker_container.id)
        redirect_to containers_url, notice: "Container was successfully created."
      else
        # Handle the case where the Docker container does not provide an ID
        flash[:alert] = "Container creation failed for an unknown reason."
        render :new, status: :unprocessable_entity
      end
    else
      # This block is reached if the form validation fails
      render :new, status: :unprocessable_entity
    end
  end
  
  

  # PATCH/PUT /containers/1 or /containers/1.json
  def update
    respond_to do |format|
      if @container.update(container_params)
        format.html { redirect_to container_url(@container), notice: "Container was successfully updated." }
        format.json { render :show, status: :ok, location: @container }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @container.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /containers/1 or /containers/1.json
  def destroy
    @container.destroy!

    respond_to do |format|
      format.html { redirect_to containers_url, notice: "Container was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_docker_url
      if ENV['INSIDE_DOCKER'].present?
        Docker.url = 'unix://var/run/docker.sock'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_container
      @container = Docker::Container.get(params[:id])
    rescue Docker::Error::DockerError => e
      @error = "Failed to get container #{e.message}"
    end

    # Only allow a list of trusted parameters through.
    def container_params
      params.require(:container_form).permit(:name, :image, :exposed_ports, :port_bindings, :always_pull)
    end
end
