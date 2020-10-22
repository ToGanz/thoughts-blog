class PostsController < ApplicationController
  before_action :require_user, except: [:show, :index]

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
    if @post.save
      flash[:notice] = "Post was created succesfully."
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
  
end
