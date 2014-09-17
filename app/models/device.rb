class Device < ActiveRecord::Base
  unloadable
  
  attr_accessible :picture, :name, :owner, :date_to, :date_from

  has_attached_file :picture, :styles => { :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :name, :owner
  validate :valid_date_to


  def valid_date_to
    unless !date_to
      if date_to < date_from
        errors.add :date_to, :date_to_greater_then_dato_from
      end
    end
  end
end
