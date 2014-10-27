class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :update]
  before_action :get_ticket, only: [:own, :show, :update]

  def index
    @tickets = Ticket.all
  end

  def open
    @tickets = Ticket.open
  end

  def closed
    @tickets = Ticket.closed
  end

  def unassigned
    @tickets = Ticket.unassigned
  end

  def status
    key = params.require(:status_key)
    @status = Status.find_by_key key
    @tickets = Ticket.for_status key
  end

  def search
    @tickets = []

    if params[:query]
      @tickets = Ticket.search params[:query]
    end
  end

  def own
    @ticket.take_ownership! current_user
    redirect_to ticket_path(@ticket)
  end

  def update
    
    if @ticket.update_attributes strong_params
      redirect_to ticket_path @ticket
    else
      render :show
    end

  end

  def show
    @ticket.comments.build(user_id: current_user.try(:id))
  end

  private

  def get_ticket
    @ticket = Ticket.friendly.find(params.require(:id))
  end

  def strong_params
    if current_user
      params.require(:ticket).permit :status_key, comments_attributes:[:email, :text, :user_id]
    else
      params.require(:ticket).permit comments_attributes:[:email, :text, :user_id]
    end
  end
end
