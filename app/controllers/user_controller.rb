class UserController < ApplicationController
  def show
      @username=params[:username]
      @user = User.where("username LIKE ?",@username)
      @user=@user[0]
  end
end
