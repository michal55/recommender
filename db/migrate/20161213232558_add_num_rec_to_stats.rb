class AddNumRecToStats < ActiveRecord::Migration
  def change
    add_column :stats, :num_rec, :integer
  end
end
