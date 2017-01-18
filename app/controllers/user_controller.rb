class UserController < ApplicationController

  def show
      if user_signed_in?
        @new_comment = Comment.build_from(@post, current_user.id, "")
      end
      @username=params[:username]
      @user = User.where("username LIKE ?",@username)
      @user=@user[0]


      @submitted=@user.posts
      @submitted+=Comment.where("user_id LIKE ?",@user.id)
      @submitted=@submitted.sort_by(&:created_at).reverse.take(20)

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
      @liked=@liked.sort_by(&:created_at).reverse.take(20)

      @disliked=@user.find_down_voted_items
      @disliked=@disliked.compact
      @disliked=@disliked.sort_by(&:created_at).reverse.take(20)



  end

  def direct_message
    @user=User.find(params[:user])
  end

  def send_direct_message
    @subject=params[:subject]
    @message=params[:message]
    @recipient=User.find(params[:recipient])
    UserMailer.direct_message(@subject,@message,current_user,@recipient).deliver
    flash[:success]= "Your message was sent to #{@recipient.username}!"
    respond_to do |format|
      format.html { redirect_to root_url, success: "Your message was sent!" }
      format.json { head :no_content }
    end
  end
end
