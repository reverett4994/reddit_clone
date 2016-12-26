class SubredditsController < ApplicationController
  before_action :set_subreddit, only: [:show, :edit, :update, :destroy]
  WillPaginate.per_page = 3

  # GET /subreddits
  # GET /subreddits.json
  def index
    @subreddits = Subreddit.all
  end

  # GET /subreddits/1
  # GET /subreddits/1.json
  def show
    @posts=@subreddit.posts
  end

  def top
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

  end

  def newist
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
      format.html { redirect_to subreddits_url, notice: 'Subreddit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def subscribe
    @subreddit=Subreddit.friendly.find(params[:id])
    @subreddit.users<<current_user unless @subreddit.users.include?(current_user)
    current_user.subreddits<<@subreddit unless current_user.subreddits.include?(@subreddit)
  end

  def admin
    @subreddit=Subreddit.friendly.find(params[:id])
    @subreddit.admins<<current_user.admin unless @subreddit.admins.include?(current_user.admin)
    current_user.admin.subreddits<<@subreddit unless current_user.admin.subreddits.include?(@subreddit)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subreddit
      @subreddit=Subreddit.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subreddit_params
      params.require(:subreddit).permit(:name, :description, :slug)
    end
end
