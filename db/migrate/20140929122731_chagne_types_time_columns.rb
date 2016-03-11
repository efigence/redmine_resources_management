class ChagneTypesTimeColumns < ActiveRecord::Migration
	def up
		change_column :loans, :phone_time, :float
		change_column :loans, :email_time, :float
	end

	def down
		change_column :loans, :phone_time, :integer
		change_column :loans, :email_time, :integer
	end
end
