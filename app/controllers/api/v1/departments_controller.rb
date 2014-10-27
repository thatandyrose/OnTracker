module Api
  module V1

    class DepartmentsController < ApplicationController
      respond_to :json

      def index
        render json: ['Sales', 'Marketing']
      end

    end

  end
end
