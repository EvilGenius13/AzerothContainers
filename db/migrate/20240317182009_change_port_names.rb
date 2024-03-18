class ChangePortNames < ActiveRecord::Migration[7.1]
  def change
    rename_column :containers, :ports, :exposed_ports
    add_column :containers, :port_bindings, :text
  end
end
