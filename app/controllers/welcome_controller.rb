class WelcomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @boards = Board.all.where(user_id: current_user.id).order(created_at: :desc)
  end

  def public
    @boards = Board.all.where(is_private: false).order(created_at: :desc)
    render json: { boards: @boards }
  end

end
