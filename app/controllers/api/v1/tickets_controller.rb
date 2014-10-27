module Api
  module V1

    class TicketsController < ApplicationController
      respond_to :json

      def create
        @ticket = Ticket.new(params.require(:ticket).permit(:subject, :body, :department, :name, :email))

        if @ticket.save
          render json: {reference: @ticket.reference}
        else
          render json: {errors: @ticket.errors}, status: :bad_request
        end
      end

    end

  end
end
