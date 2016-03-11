class DevicesController < ApplicationController
  include StatisticsHelper
  before_filter :check_permissions, only: [:new, :edit, :destroy, :create, :update, :statistics]

  def index
    @devices = Device.where('')
                     .search(params[:search])
                     .paginate(per_page: Setting.plugin_redmine_resources_management['per_page'].to_i, page: params[:page])

    respond_to do |format|
      format.html
    end
  end

  def show
    @device = Device.find(params[:id])
    @loan = Loan.new
    @loan.device_id = @device.id
    @loans = @device.loans.paginate(page: params[:page], per_page: Setting.plugin_redmine_resources_management['loans_per_page'].to_i)
  end

  def get_phone
    loan = Loan.where(borrower_id: params[:borrower_id]).last
    result = ''
    result = loan.phone if loan
    render text: result
  end

  def new
    @device = Device.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @device = Device.find(params[:id])
  end

  def create_loan
    @device = Device.find(params[:device_id])
    @loans = @device.loans.paginate(page: params[:page], per_page: Setting.plugin_redmine_resources_management['loans_per_page'].to_i)
    params[:loan][:date_of_return] = (User.current.time_zone || Time.zone).parse(params[:loan][:date_of_return])

    @loan = Loan.new(params[:loan])
    @loan.device_id = params[:device_id]

    if @loan.save
      @loan.device.change_status!
      redirect_to device_path(@loan.device)
    else
      @device = @loan.device
      render action: :show
    end
  end

  def return
    @device = Device.find(params[:device_id])
    @loan = Loan.find(params[:id])
    @loan.return!
    redirect_to device_path(@loan.device)
  end

  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      format.html do
        if @device.save
          redirect_to @device, notice: 'Device was successfully created.'
        else
          render action: 'new'
        end
      end
    end
  end

  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @device = Device.find(params[:id])
    if @device.status == 'RENTED'
      redirect_to devices_url, alert: 'You can not destroy already rented device!!'
    else
      @device.destroy
      respond_to do |format|
        format.html { redirect_to devices_url }
      end
    end
  end

  def statistics
    # @devices = Device.eager_load(loans: :user)
    @devices = Loan.joins(:user, :device)
                   .select('count(loans.id) as loans_count, devices.name, users.id as borrower_id')
                   .group('borrower_id')
                   .group('device_id')
                   .order('devices.name asc, loans_count desc')
                   .preload(:user)
                   .group_by(&:name).map do |elem|
                     { name: elem[1][0].name, count: elem[1].collect{ |w| w.loans_count }.sum, top: elem[1][0].user, top_count: elem[1][0].loans_count }
                   end
    @devices = sorted_by(@devices)
    # binding.pry
    # @devices = Device.get_sorted_by(params[:sort_by])
    respond_to do |format|
      format.html
      format.csv { send_data get_csv(@devices) }
    end
  end

  private

  def check_permissions
    deny_access unless User.current.admin? || has_access?
  end

  def has_access?
    !(user_ids & groups_with_access).blank?
  end

  def user_ids
    User.current.groups.select('id').collect { |el| el.id.to_s }
  end

  def groups_with_access
    Setting.plugin_redmine_resources_management[:groups] || []
  end

  def get_csv(devices_hash)
    column_names = ['#'] + devices_hash.first.keys
    s = CSV.generate do |csv|
      csv << column_names
      devices_hash.each.with_index do |elem, index|
        csv << [(index + 1).to_s] + elem.values
      end
    end
  end
end
