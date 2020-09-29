class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: [:update, :create, :index, :show, :edit, :new]

  def set_board
    @board = Board.find(params[:board_id])
  end

  def index
     @logs = Log.all.where(user_id: current_user.id).order(created_at: :desc)
  end

  def show
    @log = Log.find(params[:id])
  end

  def new
    @log = Log.new
    @log.board_id = params[:board_id]
  end

  def create
    @log = Log.create(log_params)
    @log.board = @board;
    @log.user_id = current_user.id
    if @log.save!
      redirect_to board_log_path(@board, @log)
    else
      render 'new'
    end
  end

  def edit
    @log = Log.find(params[:id])
  end

  def update
    @log = Log.find(params[:id])
    if @log.update(log_params)
      redirect_to board_log_path(@board, @log)
    else
      render 'edit'
    end
  end
  
  def destroy
    @log = Log.find(params[:id])
    @log.destroy
    redirect_to board_logs_path
  end

  private
    def log_params
      params.require(:log).permit(:title, :text, :tag_list, :color, :board_id)
    end
end
