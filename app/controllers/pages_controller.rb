class PagesController < ApplicationController

  def home
    @posts = Post.paginate(page: params[:page])
  end
end