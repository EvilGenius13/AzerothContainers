class MakeImageNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :containers, :image, false
  end
end
