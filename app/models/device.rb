class Device < ActiveRecord::Base
  unloadable

  attr_accessible :picture, :name, :owner, :date_to, :date_from, :status

  after_create :set_default_status
  after_save :enforce_time_report_worker, on: :update

  has_many :loans, dependent: :destroy
  has_attached_file :picture, :styles => { thumb: '100x100>', medium: '200x200' }, default_url: '/images/:style/missing.png'

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates_length_of :name, :owner, { maximum: 200 }
  validates_presence_of :name, :owner
  validate :valid_date_to, if: -> { date_to && date_from }


  def set_default_status
    if date_from && date_from > Date.today
      self.status = Loan::STATUS[:not_yet]
    else
      self.status = Loan::STATUS[:available]
    end
    save
  end

  def valid_date_to
    errors.add :date_to, :date_to_greater_then_dato_from if date_to < date_from
  end

  def change_status!
    user = User.find(loans.last.borrower_id)
    zone = user.time_zone || Time.zone
    self.status = Loan::STATUS[:unavailable]
    self.loan_date = loans.last.date_of_return.in_time_zone(zone)
    self.loans_name = loans.last.borrower_id
    save
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      where('')
    end
  end

  def enforce_time_report_worker
    reload
    borrower = loans.last.borrower_id if loans.any?
    run_worker(borrower) unless borrower.blank?
  end

  def run_worker(user_id)
    Redmine::Hook.call_hook(:run_worker_for_device_user, { user_id: user_id })
  end
end
