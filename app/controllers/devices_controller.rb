class DevicesController < ApplicationController

  before_filter :check_permissions, :only => [:new, :edit, :destroy, :create, :update]

  def index
    @devices = Device.where('').
      search(params[:search]).
      paginate(:per_page => Setting.plugin_redmine_resources_management['per_page'].to_i, :page => params[:page])

    respond_to do |format|
      format.html
    end
  end

  def show
    @device = Device.find(params[:id])
    @loan = Loan.new
    @loan.device_id = @device.id
  end

  def get_phone
    loan = Loan.where('borrower_id = ? AND phone IS NOT NULL', params[:borrower_id]).last
    result = ""
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
    params[:loan][:date_of_return] = (User.current.time_zone || Time.zone).parse(params[:loan][:date_of_return])

    @loan = Loan.new(params[:loan])
    @loan.device_id = params[:device_id]

    if @loan.save
      @loan.device.change_status!
      redirect_to device_path(@loan.device)
    else
      @device = @loan.device
      render :action => :show
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
          render action: "new"
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
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @device = Device.find(params[:id])
    if @device.status == "RENTED"
      redirect_to devices_url, alert: 'You can not destroy already rented device!!'
    else
      @device.destroy
      respond_to do |format|
        format.html { redirect_to devices_url }
      end
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
    User.current.groups.select('id').collect{|el| el.id.to_s}
  end

  def groups_with_access
    Setting.plugin_redmine_resources_management[:groups] || []
  end
end
