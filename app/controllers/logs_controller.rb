class LogsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :create, :index, :edit, :new, :destroy]
  before_action :authenticate!, only: [:show]
  before_action :set_board, only: [:update, :create, :index, :show, :edit, :new, :destroy]

  def authenticate!
    log = Log.find_by(hash_id: params[:id])
    authenticate_user! if log.is_private
  end

  def set_board
    @board = Board.find_by(hash_id: params[:board_id])
  end

  def index
    @logs = Log.all.where(user_id: current_user.id).order(created_at: :desc)
    respond_to do |format|
      format.json {
        render json: {
          logs: @logs
        }
      }
      format.html {}
    end
  end

  def show
    @log = Log.find_by(hash_id: params[:id])
    respond_to do |format|
      format.json {
        render json: {
          log: @log
        }
      }
      format.html {}
    end
  end

  def new
    @log = Log.new
    @log.board_id = params[:board_id]
  end

  def create
    @log = Log.create(log_params)
    @log.board = @board;
    @log.user_id = current_user.id
    respond_to do |format|
      format.json {
        if @log.save!
          LogMailer.new_log(@log).deliver_now unless @log.user_id != current_user.id
          render json: {
            log: @log
          }, status: :ok
        else
          render json: {
            message: "Coultn't complete your request"
          }, status: 401
        end
      }
      format.html {
        if @log.save!
          LogMailer.new_log(@log).deliver_now unless @log.user_id != current_user.id
          redirect_to board_log_path(@board, @log)
        else
          render 'new'
        end
      }
    end
  end

  def edit
    @log = Log.find_by(hash_id: params[:id])
  end

  def update
    @board = Board.find_by(hash_id: params[:board_id])
    @log = Log.find_by(hash_id: params[:id])
    if @log.update(log_params)
      redirect_to board_log_path(@board, @log)
    else
      render 'edit'
    end
  end
  
  def destroy
    @log = Log.find_by(hash_id: params[:id])
    @log.destroy
    LogMailer.deleted_log(@log).deliver_now
    redirect_to board_path(@board)
  end

  def search
    @logs = Log.search(params[:search])
    respond_to do |format|
      format.json{
        render json: {
          logs: @logs
        }
      }
      format.html {}
    end
  end

  private
    def log_params
      params.require(:log).permit(:title, :text, :tag_list, :board_id, :search, :is_private, :bluried)
    end
end
