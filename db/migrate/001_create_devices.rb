class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string 'name'
      t.string 'owner'
      t.date 'date_from'
      t.date 'date_to'
      t.timestamps
    end
  end
end
