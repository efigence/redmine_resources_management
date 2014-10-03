class ChangeDeviceLoanType < ActiveRecord::Migration
  def up
    change_column :devices, :loan_date, :datetime
    change_column :devices, :loans_name, :integer
  end

  def down
    change_column :devices, :loan_date, :string
    change_column :devices, :loans_name, :string
  end
end
