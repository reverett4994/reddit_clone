class SubredditsController < ApplicationController
  before_action :set_subreddit, only: [:show, :edit, :update, :destroy]
  WillPaginate.per_page = 5

  # GET /subreddits
  # GET /subreddits.json
  def index
    @subreddits = Subreddit.all
  end

  # GET /subreddits/1
  # GET /subreddits/1.json
  def show
    redirect_to top_path(subreddit:@subreddit)
    @posts=@subreddit.posts
    @subreddit=Subreddit.friendly.find(params[:id])
    @posts=[]
    @subreddits=Subreddit.where("name LIKE ?",params[:id])
    @subreddits.each do |subreddit|
      @posts+=subreddit.posts
    end
    @posts_sorted={}
    @posts.each do |post|
      @posts_sorted[post]=(post.get_upvotes.size)-(post.get_dislikes.size)
    end
    @ordered_posts = ActiveSupport::OrderedHash[*@posts_sorted.sort_by{|k,v| v}.reverse.flatten]
    @ordered_posts_keys= @ordered_posts.keys.paginate(:page => params[:page])
  end

  def top
    if params[:subreddit]==nil
      @focus=false
      if user_signed_in?
        @subreddits=current_user.subreddits
      else
        @subreddits=Subreddit.default
      end
      @posts=[]
      @subreddits.each do |subreddit|
        @posts+=subreddit.posts
      end
      @posts_sorted={}
      @posts.each do |post|
        @posts_sorted[post]=(post.get_upvotes.size)-(post.get_dislikes.size)
      end
      @ordered_posts = ActiveSupport::OrderedHash[*@posts_sorted.sort_by{|k,v| v}.reverse.flatten]
      @ordered_posts_keys= @ordered_posts.keys.paginate(:page => params[:page])
    else
      @focus=params[:subreddit]
      @subreddit=Subreddit.friendly.find(params[:subreddit])
      @posts=[]
      @subreddits=Subreddit.where("name LIKE ?",params[:subreddit])
      @subreddits.each do |subreddit|
        @posts+=subreddit.posts
      end
      @posts_sorted={}
      @posts.each do |post|
        @posts_sorted[post]=(post.get_upvotes.size)-(post.get_dislikes.size)
      end
      @ordered_posts = ActiveSupport::OrderedHash[*@posts_sorted.sort_by{|k,v| v}.reverse.flatten]
      @ordered_posts_keys= @ordered_posts.keys.paginate(:page => params[:page])
    end
  end

  def all
    @posts=[]
    @subreddits=Subreddit.all
    @subreddits.each do |subreddit|
      @posts+=subreddit.posts
    end
    @posts_sorted={}
    @posts.each do |post|
      @posts_sorted[post]=(post.get_upvotes.size)-(post.get_dislikes.size)
    end
    @ordered_posts = ActiveSupport::OrderedHash[*@posts_sorted.sort_by{|k,v| v}.reverse.flatten]
    @ordered_posts_keys= @ordered_posts.keys.paginate(:page => params[:page])
  end

  def newist
    if params[:subreddit]==nil
      @focus=false
      @posts=[]
      if user_signed_in?
        @subreddits=current_user.subreddits
      else
        @subreddits=Subreddit.default
      end
      @subreddits.each do |subreddit|
        @posts+=subreddit.posts
      end
      @ordered_posts=@posts.sort_by &:created_at
      @ordered_posts.reverse!
      @ordered_posts= @ordered_posts.paginate(:page => params[:page])
    else
      @focus=params[:subreddit]
      @subreddit=Subreddit.friendly.find(params[:subreddit])
      @posts=[]
      @subreddits=Subreddit.where("name LIKE ?",params[:subreddit])
      @subreddits.each do |subreddit|
        @posts+=subreddit.posts
      end
      @ordered_posts=@posts.sort_by &:created_at
      @ordered_posts.reverse!
      @ordered_posts= @ordered_posts.paginate(:page => params[:page])
    end
  end

  def search
    @search=params[:search]
    @subreddits=Subreddit.where("name LIKE ?",@search)
    @subreddits= @subreddits.paginate(:page => params[:page])

  end

  # GET /subreddits/new
  def new
    @subreddit = Subreddit.new
  end

  # GET /subreddits/1/edit
  def edit
  end

  # POST /subreddits
  # POST /subreddits.json
  def create
    @subreddit = Subreddit.new(subreddit_params)

    respond_to do |format|
      if @subreddit.save
        format.html { redirect_to @subreddit, notice: 'Subreddit was successfully created.' }
        format.json { render :show, status: :created, location: @subreddit }
      else
        format.html { render :new }
        format.json { render json: @subreddit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subreddits/1
  # PATCH/PUT /subreddits/1.json
  def update
    respond_to do |format|
      if @subreddit.update(subreddit_params)
        format.html { redirect_to @subreddit, notice: 'Subreddit was successfully updated.' }
        format.json { render :show, status: :ok, location: @subreddit }
      else
        format.html { render :edit }
        format.json { render json: @subreddit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subreddits/1
  # DELETE /subreddits/1.json
  def destroy
    @subreddit.destroy
    respond_to do |format|
      format.html { redirect_to subreddits_url, notice: "Subreddit was Destroyed" }
      format.json { head :no_content }
    end
  end

  def subscribe
    @subreddit=Subreddit.friendly.find(params[:id])
    @subreddit.users<<current_user unless @subreddit.users.include?(current_user)
    current_user.subreddits<<@subreddit unless current_user.subreddits.include?(@subreddit)
    respond_to do |format|
      flash[:success]= "Subscribed to Subreddit #{@subreddit.name}"
      format.html { redirect_to (:back)}
      format.json { head :no_content }
    end
  end
  def unsubscribe
    @subreddit=Subreddit.friendly.find(params[:id])
    @subreddit.users-=[current_user]
    current_user.subreddits-=[@subreddit]
    respond_to do |format|
      flash[:success] ="Un-Subscribed from #{@subreddit.name}"
      format.html { redirect_to (:back)}
      format.json { head :no_content }
    end
  end

  def admin
    @subreddit=Subreddit.friendly.find(params[:id])
    @password_attempt=params[:password]
    if @subreddit.password==@password_attempt
      @password_attempt='worked!'
      @subreddit.admins<<current_user.admin unless @subreddit.admins.include?(current_user.admin)
      current_user.admin.subreddits<<@subreddit unless current_user.admin.subreddits.include?(@subreddit)
      redirect_to(:back)
      flash[:success] ="Password was Correct! Your Now a Mod of #{@subreddit.name}!"
    else
      redirect_to(:back)
      flash[:danger] ="Password was Incorrect!"
    end
  end
  def removeadmin
    @subreddit=Subreddit.friendly.find(params[:id])
      @password_attempt='worked!'
      @subreddit.admins-=[current_user.admin]
      current_user.admin.subreddits-=[@subreddit]
      redirect_to(:back)
      flash[:success] ="You Are no Longer a Mod of #{@subreddit.name}!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subreddit
      @subreddit=Subreddit.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subreddit_params
      params.require(:subreddit).permit(:name, :description, :slug,:image_url,:rules,:message,:password)
    end
end
