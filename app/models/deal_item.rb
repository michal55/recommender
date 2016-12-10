class DealItem < ActiveRecord::Base
	has_many :activities
	has_many :details
end
