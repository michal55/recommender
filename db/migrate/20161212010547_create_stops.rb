class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :word

      t.timestamps null: false
    end
  end
end
