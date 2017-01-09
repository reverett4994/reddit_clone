class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post= Post.find(params[:id])
    @post_comments=@post.root_comments

    @comments_sorted={}
    @post.root_comments.each do |post|
      @comments_sorted[post]=(post.get_upvotes.size)-(post.get_dislikes.size)
    end

    @best_commentss = ActiveSupport::OrderedHash[*@comments_sorted.sort_by{|k,v| v}.reverse.flatten]
    @best_comments_ids=[]
    @best_commentss.keys.each do |comment|
      @best_comments_ids<<comment.id
    end

    @best_comments=Comment.where(id: @best_comments_ids).order("FIELD(id, #{@best_comments_ids.join(', ')})")

    @ordered_comments = @post_comments.sort_by &:created_at
    @new_comments =@ordered_comments.reverse
    
    if user_signed_in?
      @new_comment = Comment.build_from(@post, current_user.id, "")
    end
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        flash[:success]= 'Post Was Created'
        format.html { redirect_to @post.subreddit }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      flash[:success]= "Post Was Deleted"
      format.html { redirect_to :back}
      format.json { head :no_content }
    end
  end

  def vote
    @post=Post.where("ID LIKE ?",params[:id])
    @post=@post.last
    @vote=params[:vote]
    if @vote=="up"
      @post.upvote_by current_user
      #ADD A @post.unliked_by @user1 IN AN IF STATMENT!!
    else
      @post.downvote_by current_user
      #ADD A @post.undisliked_by @user1 IN AN IF STATMENT!!
    end
    respond_to do |format|
    format.xml  { render :xml => @post }
    format.json { render :json => (@post.get_upvotes.size)-(@post.get_downvotes.size) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image_link,:subreddit_id)
    end
end
