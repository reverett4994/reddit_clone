class UserController < ApplicationController
  WillPaginate.per_page = 3
  def show
      @username=params[:username]
      @user = User.where("username LIKE ?",@username)
      @user=@user[0]
      @posts=@user.posts
      @posts= @posts.paginate(:page => params[:page])
  end
end
