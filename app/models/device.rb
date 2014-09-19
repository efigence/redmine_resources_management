class Device < ActiveRecord::Base
  unloadable
  
  attr_accessible :picture, :name, :owner, :date_to, :date_from, :status

  after_create :set_default_status

  has_many :loans, dependent: :destroy
  has_attached_file :picture, :styles => { :thumb => "100x100>", :medium => "200x200" }, :default_url => "/images/:style/missing.png"
  
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :name, :owner
  validate :valid_date_to
  
  def set_default_status
    self.status = "Now Available"
    self.save
  end

  def valid_date_to
    unless !date_to
      if date_to < date_from
        errors.add :date_to, :date_to_greater_then_dato_from
      end
    end
  end

  def change_status!
    self.status = Loan::STATUS[:unavailable]
    self.loan_date = self.loans.last.date_of_return
    self.loans_name = self.loans.last.borrower_name
    self.save
  end

  def self.search search
    if search
      where('name LIKE ?', "%#{search}%")
    else 
      where('')
    end
  end
end
