class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_ticket, only: [:own, :show]

  def open
    @tickets = Ticket.open
  end

  def own
    @ticket.take_ownership! current_user
    redirect_to ticket_path(@ticket)
  end

  def show
  end

  private

  def get_ticket
    @ticket = Ticket.find(params.require(:id))
  end
end
