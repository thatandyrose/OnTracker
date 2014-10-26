class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :update]
  before_action :get_ticket, only: [:own, :show, :update]

  def open
    @tickets = Ticket.open
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
    params.require(:ticket).permit comments_attributes:[:email, :text, :user_id]
  end
end
