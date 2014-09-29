class Loan < ActiveRecord::Base
  unloadable

  STATUS = {:available => 'RETURNED', :unavailable => 'RENTED'}

  attr_accessible :borrower_name, :device_id, :date_of_hire, :date_of_return, :status, :phone, :email_notify, :phone_notify
  belongs_to :device

  validates_presence_of :borrower_name, :date_of_hire, :date_of_return, :status
  validate :date_of_return_higher
  validate :time_of_hire
  validate :notify_validation

  def return!
    dev = Device.find(self.device_id)
    dev.status = STATUS[:available]
    dev.loan_date = nil
    dev.loans_name = nil
    self.status = STATUS[:available]
    self.date_of_return = Time.now
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
    dev = Device.find(self.device_id)
    unless dev.date_to.blank?
      unless !date_of_return
        if dev.date_to < self.date_of_return.to_date
          errors.add :date_of_return, :less_then_avalible_date
        end
      end
    end
  end

  def notify_validation
    if self.email_notify == false && self.phone_notify == false
      errors.add :email_notify, :choose_notification
      errors.add :phone_notify, :choose_notification
    elsif self.phone_notify == true && self.phone.nil?
      errors.add :phone, :phone_require_if_phone_notify
    end
  end
end
