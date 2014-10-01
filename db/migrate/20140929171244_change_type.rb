class ChangeType < ActiveRecord::Migration
	def up
		change_column :loans, :phone, :string
	end

	def down
		change_column :loans, :phone, :integer
	end
end
