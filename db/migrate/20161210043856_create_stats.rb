class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :hits
      t.integer :total

      t.timestamps null: false
    end
  end
end
