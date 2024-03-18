module ContainersHelper
  def humanize_bytes(bytes)
    units = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB']
    return '0 Bytes' if bytes.to_i <= 0
    i = (Math.log(bytes) / Math.log(1024)).floor
    sprintf("%.2f %s", bytes.to_f / (1024 ** i), units[i])
  end

  def create_container_params(params)
    container_params = params[:container_form] || {}
    puts "Container Parameters: #{container_params}"
  
    filtered_params = container_params.reject { |key, value| value.blank? }
    puts "Filtered Parameters: #{filtered_params}"
  
    allowed_keys = ['Image', 'name', 'ExposedPorts', 'PortBindings']
    docker_options = {}
  
    filtered_params.each do |key, value|
      docker_key = key == 'name' ? 'name' : key.camelize
  
      if allowed_keys.include?(docker_key)
        case docker_key
        when 'ExposedPorts'
          # Only handling TCP
          port_with_protocol = "#{value}/tcp"
          docker_options['ExposedPorts'] = { port_with_protocol => {} }
        when 'PortBindings'
          # Only handling TCP & using filtered params port which is why it's not camelized.
          internal_port_with_protocol = "#{filtered_params['exposed_ports']}/tcp"
          external_port = "#{value}"
          docker_options['HostConfig'] ||= {}
          docker_options['HostConfig']['PortBindings'] = { internal_port_with_protocol => [{ 'HostPort' => external_port }] }
        else
          docker_options[docker_key] = value
        end
      end
    end
  
    puts "Docker Options: #{docker_options}"
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
    true
  rescue Docker::Error::DockerError => e
    puts "Error pulling image: #{e.message}"
    false
  end

  def handle_image_pull(image_name, always_pull)
    if always_pull || !image_exists_locally?(image_name)
      pull_image(image_name)
    else
      puts "Using local image: #{image_name}"
    end
  end
end
