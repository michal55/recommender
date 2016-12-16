class AddKeywordsToDetail < ActiveRecord::Migration
  def change
    add_column :test_details, :keywords, :text, array:true, default: []
  end
end
