class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, current_user.id, body)

    respond_to do |format|
      if @comment.save
        flash[:success]= 'Comment Was Created'
        make_child_comment
        format.html  { redirect_to(:back) }
      else
        flash[:error]= "Error When Creating Comment, It Needs to Have SOME Content! Try Again."
        format.html { redirect_to :back }
      end
    end
  end

  def vote
    @comment=Comment.where("ID LIKE ?",params[:id])
    @comment=@comment.last
    @vote=params[:vote]
    if @vote=="up"
      @comment.upvote_by current_user
      #ADD A @post.unliked_by @user1 IN AN IF STATMENT!!
    else
      @comment.downvote_by current_user
      #ADD A @post.undisliked_by @user1 IN AN IF STATMENT!!
    end
    respond_to do |format|
    format.xml  { render :xml => @comment }
    format.json { render :json => (@comment.get_upvotes.size)-(@comment.get_downvotes.size) }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back, success: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def moddestroy
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml =>  UserMailer.comment_mod_delete(params[:reason],params[:user],params[:post]).deliver }
      format.json { render :json =>  UserMailer.comment_mod_delete(params[:reason],params[:user],params[:post]).deliver }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return "" if comment_id.blank?

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end

end
