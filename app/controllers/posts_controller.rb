class PostsController < ApplicationController
  before_action :require_user, except: [:show, :index]

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.paginate(page: params[:page])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
end
