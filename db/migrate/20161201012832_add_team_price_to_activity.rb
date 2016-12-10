class AddTeamPriceToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :team_price, :float
  end
end
