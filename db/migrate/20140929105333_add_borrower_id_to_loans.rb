class AddBorrowerIdToLoans < ActiveRecord::Migration
	def change
		add_column :loans, :borrower_id, :integer
	end
end
