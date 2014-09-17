class DevicesController < ApplicationController
  
  def index
    @devices = Device.all

    respond_to do |format|
      format.html
      format.json { render json: @devices }
    end
  end

  def show
    @device = Device.find(params[:id])
  end

  def new
    @device = Device.new

    respond_to do |format|
      format.html 
      format.json { render json: @device }
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
        format.json { render json: @device, status: :created, location: @device }
      else
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end
end
