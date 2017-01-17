class UserController < ApplicationController
  WillPaginate.per_page = 90
  def show
      if user_signed_in?
        @new_comment = Comment.build_from(@post, current_user.id, "")
      end
      @username=params[:username]
      @user = User.where("username LIKE ?",@username)
      @user=@user[0]


      @submitted=@user.posts
      @submitted+=Comment.where("user_id LIKE ?",@user.id)
      @submitted=@submitted.sort_by(&:created_at).reverse
      @submitted= @submitted.paginate(:page => params[:page], :per_page => 300)
      @post_karma=0
      @comment_karma=0
      @submitted.each do |thing|
        if thing.class==Post
          @post_karma+=(thing.get_upvotes.size)-(thing.get_downvotes.size)
         else
           @comment_karma+=(thing.get_upvotes.size)-(thing.get_downvotes.size)
        end
      end


      @liked=@user.find_up_voted_items
      @liked=@liked.compact
      @liked=@liked.sort_by(&:created_at).reverse

      @disliked=@user.find_down_voted_items
      @disliked=@disliked.compact
      @disliked=@disliked.sort_by(&:created_at).reverse


      @disliked= @disliked.paginate(:page => params[:page], :per_page => 300)
  end

  def direct_message
    @user=User.find(params[:user])
  end
end
