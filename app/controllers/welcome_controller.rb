class WelcomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @boards = Board.all.where(user_id: current_user.id).order(created_at: :desc)
    @sharedBoards = User.find(current_user.id).user_boards.map do |user_board| user_board.board end
  end

  def public
    @boards = Board.all.where(is_private: false).order(created_at: :desc)
    render json: { boards: @boards }
  end

end
