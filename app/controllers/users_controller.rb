class UsersController < ApplicationController
  before_action :authenticate_user!

  def unapproved
    @users = User.unapproved
  end

  def approve
    user = User.find(params.require(:id))
    user.update_attributes! approved: true

    redirect_to unapproved_users_path, notice: "User #{user.email} approved"
  end
end
