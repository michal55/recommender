class AddEvalToStats < ActiveRecord::Migration
  def change
    add_column :stats, :eval, :string
  end
end
