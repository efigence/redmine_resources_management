class AddTimeFieldsToLoans < ActiveRecord::Migration
	def change
		add_column :loans, :email_time, :integer
		add_column :loans, :phone_time, :integer
	end
end
