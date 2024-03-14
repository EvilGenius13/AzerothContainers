require 'docker'

class ContainersController < ApplicationController
  before_action :set_docker_url
  before_action :set_container, only: %i[ show edit update destroy ]

  # GET /containers or /containers.json
  def index
    # Docker.url = 'unix://var/run/docker.sock'
    @containers = Docker::Container.all(all: true)
  rescue Docker::Error::DockerError => e
    @error = "Failed to connect to Docker daemon #{e.message}"
  end

  # GET /containers/1 or /containers/1.json
  def show
  end

  # Start container
  def start
    container = Docker::Container.get(params[:id])
    container.start
    redirect_to containers_url, notice: "Container was succesfully started."
  rescue Docker::Error::DockerError => e
    redirect_to containers_url, alert: "Failed to start container: #{e.message}"
  end

  # GET /containers/new
  def new
    @container = Container.new
  end

  # GET /containers/1/edit
  def edit
  end

  # POST /containers or /containers.json
  def create
    @container = Container.new(container_params)

    respond_to do |format|
      if @container.save
        format.html { redirect_to container_url(@container), notice: "Container was successfully created." }
        format.json { render :show, status: :created, location: @container }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @container.errors, status: :unprocessable_entity }
      end
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
      # Docker.url = 'unix://var/run/docker.sock'
      @container = Docker::Container.get(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def container_params
      params.require(:container).permit(:name, :status)
    end
end
