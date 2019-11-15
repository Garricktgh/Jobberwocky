class MessagesController < ApplicationController

  def index
    if (user_signed_in?)
      @user = current_user
      @matches = Status.where(user_id: @user.id, post_approval: "accept", user_approval: "accept")
      @messages = Message.select('DISTINCT ON ("post_id") *').order(:post_id, created_at: :desc, id: :desc).where(user_id: current_user)
    elsif (company_signed_in?)
      @company = current_company
      @post = Post.where(company_id: current_company.id)
      @matches = Status.where(post_id: [@post.ids], post_approval: "accept", user_approval: "accept")
      @messages = Message.select('DISTINCT ON ("post_id") *').order(:post_id, created_at: :desc, id: :desc).where(post_id: [@post.ids])
    end

  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if (company_signed_in?)
      @message.sender = "post"

      elsif user_signed_in?
        @message.sender = "user"
    end

    @message.user_id =
    @message.post_id =


    if(@message.save)
      redirect_to @message
    else
      render 'new'
    end
  end

  def show
    @message = Message.find_by(id: params[:id])
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: params[:id])
  end

  def edit
    @message = Message.find_by(id: params[:id])
  end

  def update
    @message = Message.find_by(id: params[:id])
    @message.update(message_params)
    redirect_to root_path
  end

  def destroy

  end

  private
  def message_params
    params.require(:message).permit(:content)
  end
end