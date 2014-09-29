class AddPhoneAndEmailNotify < ActiveRecord::Migration
	def change
		add_column :loans, :phone_notify, :boolean
		add_column :loans, :email_notify, :boolean
	end
end
