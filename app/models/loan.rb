class Loan < ActiveRecord::Base
  unloadable

  STATUS = { available: 'AVAILABLE', unavailable: 'UNAVAILABLE', not_yet: 'UNAVAILABLE YET' }

  attr_accessible :device_id, :date_of_hire, :date_of_return, :status, :phone,
    :email_notify, :phone_notify, :borrower_id, :phone_time, :email_time, :description

  belongs_to :device
  belongs_to :user, foreign_key: :borrower_id

  before_create :set_values_without_notify
  after_create :prepare_to_send_notification

  validates_presence_of :borrower_id, :date_of_hire, :date_of_return, :status

  validates_format_of :phone, with: /\A\+\d{11}\z/i, message: :wrong_format,
    allow_blank: true, allow_nil: true, if: :phone_notify

  validates_numericality_of :phone, :phone_time, allow_nil: false, allow_blank: false, if: :phone_notify
  validates_numericality_of :email_time, allow_nil: false, allow_blank: false, if: :email_notify

  validate :date_of_return_higher
  validate :time_of_hire, if: :date_of_return

  def return!
    device.status = STATUS[:available]
    device.loan_date, device.loans_name = nil, nil
    self.status = STATUS[:available]
    self.date_of_return = Time.now
    check_for_notifications id, borrower_id
    device.save
    save
  end

  def prepare_to_send_notification
    user = User.find(borrower_id)
    notify_by_email(user) if email_notify == true
    notify_by_sms(user) if phone_notify == true
  end

  def set_values_without_notify
    self.phone = nil unless phone_notify
    self.phone_time = nil unless phone_notify
    self.email_time = nil unless email_notify
  end

  def notify_by_email(user)
    notification = Notification.new
    notification.notifiable_id = id
    notification.notifiable_type = 'Device'
    notification.planning_send_at = (date_of_return - email_time.hours)
    notification.to = user.mail
    notification.kind = :mail
    notification.user_id = user.id
    notification.subject = "#{device.name} " + 'should be return for' + " #{email_time} h."
    notification.content = "#{device.name} should be returned at #{date_of_return} otherwise your internet will be blocked!"
    notification.save
  end

  def notify_by_sms(user)
    notification = Notification.new
    notification.notifiable_id = id
    notification.notifiable_type = 'Device'
    notification.planning_send_at = (date_of_return - phone_time.hours)
    notification.to = phone
    notification.kind = :sms
    notification.user_id = user.id
    notification.content = "#{device.name} should be return for #{email_time} h."
    notification.save
  end

  def check_for_notifications(loan_id, user_id)
    Notification.where('user_id = ? AND notifiable_id = ? AND sent_at IS NULL', user_id, loan_id).destroy_all
  end

  def date_of_return_higher
    errors.add :date_of_return, :greater_then_date_of_hire if date_of_hire && date_of_return && date_of_hire > date_of_return
  end

  def time_of_hire
    unless device.date_to.blank?
      errors.add :date_of_return, :less_then_avalible_date if device.date_to < date_of_return.to_date
    end
  end
end
