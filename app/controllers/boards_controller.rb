class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:share]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @boards = Board.all.where(user_id: current_user.id).order(created_at: :desc)
  end
  
  def show
    authorize @board
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.create(board_params)
    @board.user_id = current_user.id
    if @board.save!
      redirect_to boards_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      redirect_to @board
    else
      render 'edit'
    end
  end
  
  def destroy
    @board.destroy
    redirect_to boards_path
  end

  def set_board
    @board = Board.find_by(hash_id: params[:id])
  end

  def share
    user_ids = params[:ids]
    board_id = params[:board_id]
    responses = []
    user_ids.each do |user_id|
      relation = UserBoard.new
      relation.user_id = user_id
      relation.board_id = board_id
      responses.push(relation.save!)
      BoardMailer.shared_board(relation).deliver_now
    end
    render json: responses
  end

  private
    def user_not_authorized
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to(request.referrer || root_path)
    end

  private
    def board_params
      params.require(:board).permit(:name, :is_private, :id)
    end
end
