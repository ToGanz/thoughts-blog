class CommentsController < ApplicationController
  before_action :require_user
  before_action :require_admin, only: [:destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id if logged_in?


    if @comment.save
      flash[:notice] = "Comment was created succesfully."
    end
    redirect_to post_path(@comment.post_id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to post_path(@comment.post_id)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
