class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: [:edit, :update, :destroy, :show]
  skip_before_action :verify_authenticity_token, only: [:share]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    boards = Board.all.where(user_id: current_user.id).order(created_at: :desc)
    sharedBoards = User.find(current_user.id).user_boards.map do |user_board| user_board.board end
    respond_to do |format|
      format.json {
        render json: {
          boards: boards,
          sharedBoards: sharedBoards
        }
      }
      format.html {
        @boards = boards
        @sharedBoards = sharedBoards
      }
    end
  end
  
  def show
    respond_to do |format|
      format.json {
        logs = @board.logs.map{ |log| LogSerializer.new(log).serializable_hash[:data][:attributes] }
        render json: {
          board: @board,
          logs: logs
        }, status: :ok
      }
      format.html {
        authorize @board
      }
    end
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.create(board_params)
    @board.user_id = current_user.id
    saved = @board.save!
    respond_to do |format|
      format.json {
        render json: {
          board: @board
        }, status: :ok
      }
      format.html {
        if saved
          redirect_to boards_path
        else
          render 'new'
        end
      }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      format.json {
        if @board.user_id === current_user.id
          updated = @board.update(board_params)
          render json: {
            board: updated
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't complete your request."
          }, status: :unauthorized
        end
      }
      format.html {
        if @board.update(board_params)
          redirect_to @board
        else
          render 'edit'
        end
      }
    end
  end
  
  def destroy
    respond_to do |format|
      format.json {
        @board.destroy
        render json: {
          status: 204,
          message: "Board deleted succesfully"
        }, status: 204
      }
      format.html {
        @board.destroy
        redirect_to boards_path
      }
    end
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
