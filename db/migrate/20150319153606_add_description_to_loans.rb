class AddDescriptionToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :description, :text
  end
end
