class AddTypeToStats < ActiveRecord::Migration
  def change
    add_column :stats, :strategy, :string
  end
end
