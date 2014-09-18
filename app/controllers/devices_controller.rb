class DevicesController < ApplicationController
  
  before_filter :check_permissions, :only => [:new, :edit, :destroy, :create, :update]
  
  def index
    @devices = Device.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @device = Device.find(params[:id])
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

  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
      else
        format.html { render action: "new" }
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
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
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
