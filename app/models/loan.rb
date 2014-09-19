class Loan < ActiveRecord::Base
  unloadable

  STATUS = {:available => 'RETURNED', :unavailable => 'RENTED'}
  
  attr_accessible :borrower_name, :device_id, :date_of_hire, :date_of_return, :status
  belongs_to :device

  validates_presence_of :borrower_name, :date_of_hire, :date_of_return, :status
  validate :date_of_return_higher
  validate :time_of_hire
  
  def return!
    dev = Device.find(self.device_id)
    dev.status = STATUS[:available]
    dev.loan_date = nil
    dev.loans_name = nil
    self.status = STATUS[:available]
    self.date_of_return = Time.current.to_datetime.to_formatted_s(:long)

    dev.save
    self.save
  end

  def date_of_return_higher
    unless !date_of_return
      if date_of_hire > date_of_return
        errors.add :date_of_return, :greater_then_date_of_hire
      end
    end
  end

  def time_of_hire
    unless !date_of_return
      dev = Device.find(self.device_id)
      if dev.date_to < self.date_of_return.to_date
        errors.add :date_of_return, :less_then_avalible_date
      end
    end
  end


end
