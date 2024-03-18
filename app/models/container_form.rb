# app/forms/container_form.rb
class ContainerForm
  include ActiveModel::Model

  attr_accessor :image, :name, :exposed_ports, :port_bindings, :always_pull

  # Validations
  validates :image, presence: true
  validate :name_must_be_hyphenated

  private
  def name_must_be_hyphenated
    unless name.match?(/\A[a-z0-9]+(-[a-z0-9]+)*\z/i)
      errors.add(:name, 'must contain only letters, numbers, and hyphens with no consecutive hyphens')
    end
  end
end
