module ContainersHelper
  def humanize_bytes(bytes)
    units = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB']
    return '0 Bytes' if bytes.to_i <= 0
    i = (Math.log(bytes) / Math.log(1024)).floor
    sprintf("%.2f %s", bytes.to_f / (1024 ** i), units[i])
  end

  def create_container_params(params)
    return {} unless params

    puts params
    
    filtered_params = params.reject { |key, value| value.blank? }

    puts filtered_params
    
    allowed_keys = ['Image', 'Name', 'ExposedPorts', 'PortBindings']
    docker_options = {}

    filtered_params.each do |key, value|
      docker_key = key.camelize

      docker_options[docker_key] = value if allowed_keys.include?(docker_key)
    end

    docker_options
  end

  def image_exists_locally?(image_name)
    Docker::Image.exist?(image_name)
  rescue Docker::Error::DockerError => e
    puts "Error checking if image exists locally: #{e.message}"
    false
  end

  def pull_image(image_name)
    Docker::Image.create('fromImage' => image_name)
    puts "Image pulled successfully: #{image_name}"
  rescue Docker::Error::DockerError => e
    puts "Error pulling image: #{e.message}"
  end
end
