class StatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_status, only: [:edit, :update]

  def index
    @statuses = Status.all
  end

  def new
    @status = Status.new
  end

  def create
    @status = Status.new strong_params

    if @status.save
      redirect_to statuses_path
    else
      render :new
    end
  end  

  def edit
  end

  def update
    if @status.update_attributes strong_params
      redirect_to statuses_path
    else
      render :edit
    end
  end

  private

  def get_status
    @status = Status.find(params[:id])
  end

  def strong_params
    params.require(:status).permit :label
  end
end