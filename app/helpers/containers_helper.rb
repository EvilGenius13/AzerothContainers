module ContainersHelper
  def humanize_bytes(bytes)
    units = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB']
    return '0 Bytes' if bytes.to_i <= 0
    i = (Math.log(bytes) / Math.log(1024)).floor
    sprintf("%.2f %s", bytes.to_f / (1024 ** i), units[i])
  end  
end
