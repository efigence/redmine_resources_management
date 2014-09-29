class AddPhoneToLoans < ActiveRecord::Migration

	def change
		add_column :loans, :phone, :integer
	end
end
