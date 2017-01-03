class UserController < ApplicationController
  WillPaginate.per_page = 90
  def show
      @username=params[:username]
      @user = User.where("username LIKE ?",@username)
      @user=@user[0]
      @posts=@user.posts
      @posts= @posts.paginate(:page => params[:page], :per_page => 300)
      @post_karma=0
      @posts.each do |post|
        @post_karma+=(post.get_upvotes.size)-(post.get_downvotes.size)
      end

      @liked=@user.find_up_voted_items
      @liked=@liked.compact
      @liked= @liked.paginate(:page => params[:page], :per_page => 300)
      @disliked=@user.find_down_voted_items
      @disliked=@disliked.compact
      @disliked= @disliked.paginate(:page => params[:page], :per_page => 300)
  end
end
