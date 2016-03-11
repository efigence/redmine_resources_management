class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string 'borrower_name'
      t.integer 'device_id'
      t.datetime 'date_of_hire'
      t.datetime 'date_of_return'
      t.timestamps
    end

  end
end
