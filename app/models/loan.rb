class Loan < ActiveRecord::Base
  unloadable

  STATUS = {:available => 'AVAILABLE', :unavailable => 'UNAVAILABLE', :not_yet => 'UNAVAILABLE YET'}

  attr_accessible :device_id, :date_of_hire, :date_of_return, :status, :phone,
    :email_notify, :phone_notify, :borrower_id, :phone_time, :email_time
  belongs_to :device
  before_create :check_values_without_notify_method
  after_create :prepare_to_send_notification

  validates_presence_of :borrower_id, :date_of_hire, :date_of_return, :status

  validates_numericality_of :phone, :if => :phone_notify
  validates_format_of :phone, with: /\A\+\d{11}\z/i, message: "should be +48 first", :allow_blank => true, :allow_nil => true, :if => :phone_notify
  validates_numericality_of :phone_time, :allow_nil => false, :allow_blank => false, :if => :phone_notify

  validates_numericality_of :email_time, :allow_nil => false, :allow_blank => false, :if => :email_notify

  validate :date_of_return_higher
  validate :time_of_hire


  def return!
    dev = Device.find(self.device_id)
    dev.status = STATUS[:available]
    dev.loan_date = nil
    dev.loans_name = nil
    self.status = STATUS[:available]
    self.date_of_return = Time.now
    check_for_notifications self.id, self.borrower_id
    dev.save
    self.save
  end

  def prepare_to_send_notification
    user = User.find(self.borrower_id)
    notify_by_email(user) if self.email_notify == true
    notify_by_sms(user) if self.phone_notify == true
  end

  def check_values_without_notify_method
    self.phone = nil if !self.phone_notify
    self.phone_time = nil if !self.phone_notify
    self.email_time = nil if !self.email_notify
  end

  def notify_by_email user
    notification = Notification.new
    notification.notifiable_id = self.id
    notification.notifiable_type = "Device"
    notification.planning_send_at = (date_of_return - self.email_time.hours)
    notification.to = user.mail
    notification.kind = :mail
    notification.user_id = user.id
    notification.subject = "#{Device.find(self.device_id).name} " + "should be return for" + " #{self.email_time} h."
    notification.content = "#{Device.find(self.device_id).name} should be returnder today: #{Date.today} about #{self.email_time} h.!!"
    notification.save
  end

  def notify_by_sms user
    notification = Notification.new
    notification.notifiable_id = self.id
    notification.notifiable_type = "Device"
    notification.planning_send_at = (date_of_return - self.phone_time.hours)
    notification.to = self.phone
    notification.kind = :sms
    notification.user_id = user.id
    notification.content = "#{Device.find(self.device_id).name} should be return for #{self.email_time} h."
    notification.save
  end

  def check_for_notifications loan_id, user_id
    Notification.where('user_id = ? AND notifiable_id = ?', user_id, loan_id).destroy_all
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
end
