class AddLoansNameToDevice < ActiveRecord::Migration
  def change
  	add_column :devices, :loans_name, :string
  	add_column :devices, :loan_date, :string
  end
end
