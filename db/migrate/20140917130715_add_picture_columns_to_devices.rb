class AddPictureColumnsToDevices < ActiveRecord::Migration
  def self.up
    add_attachment :devices, :picture
  end

  def self.down
    remove_attachment :devices, :picture
  end
end
