class DropBorrowerNameFromLoan < ActiveRecord::Migration
	def up
		remove_column :loans, :borrower_name
	end

	def down
	end
end
