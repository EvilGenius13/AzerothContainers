class AddDockerOptionsToContainers < ActiveRecord::Migration[7.1]
  def change
    remove_column :containers, :status
    add_column :containers, :image, :string
    add_column :containers, :command, :string
    add_column :containers, :environment_variables, :text
    add_column :containers, :ports, :text
    add_column :containers, :volumes, :text
    add_column :containers, :cpu_limit, :string
    add_column :containers, :memory_limit, :string
    add_column :containers, :restart_policy, :string
    add_column :containers, :network_mode, :string
    add_column :containers, :labels, :text
  end
end
