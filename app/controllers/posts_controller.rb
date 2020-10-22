class PostsController < ApplicationController
  before_action :require_user, except: [:show, :index]
  before_action :require_correct_user, only: :destroy

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.paginate(page: params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:notice] = "Post was created succesfully."
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "Post was updated succesfully."
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "Post deleted"
    if request.referrer.nil? || request.referrer == post_url(@post)
      redirect_to root_url 
    else
      redirect_to request.referrer
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def require_correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to(root_path) if @post.nil?
  end
  
end
