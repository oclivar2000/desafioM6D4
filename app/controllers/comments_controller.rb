# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    before_action :set_comment, only: [:destroy]
    before_action :authorize_admin!, only: [:destroy]
  
    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        redirect_to @post, notice: 'Comentario creado exitosamente.'
      else
        redirect_to @post, alert: 'No se pudo crear el comentario.'
      end
    end
  
    def destroy
      @comment.destroy
      redirect_to @post, notice: 'Comentario eliminado.'
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def set_comment
      @comment = @post.comments.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  
    def authorize_admin!
        unless current_user.admin? || @comment.user == current_user
          redirect_to @post, alert: 'No tienes permisos para realizar esta acción.'
        end
      end
  end
  

 
  