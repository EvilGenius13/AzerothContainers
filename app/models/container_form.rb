# app/forms/container_form.rb
class ContainerForm
  include ActiveModel::Model

  attr_accessor :image, :name, :exposed_ports, :port_bindings

  # Validations
  validates :image, presence: true
end
