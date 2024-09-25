class LogsController < ApplicationController
  before_action :authenticate_client_or_user!, only: [:update, :create, :index, :edit, :new, :destroy]
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
    @logs = Log.all.where(user_id: @user.id).order(created_at: :desc)
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
    boards = Board.where(user_id: current_user.id)
    @boards_options = boards.map { |board| [board.name, board.id] }
  end

  def create
    @log = Log.create(log_params)
    @log.board = @board;
    @log.user_id = @user.id
    respond_to do |format|
      format.json {
        if @log.save!
          # LogMailer.new_log(@log).deliver_now unless @log.user_id != @user.id
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
          # LogMailer.new_log(@log).deliver_now unless @log.user_id != @user.id
          redirect_to board_log_path(@board, @log)
        else
          render 'new'
        end
      }
    end
  end

  def edit
    @log = Log.find_by(hash_id: params[:id])
    boards = Board.where(user_id: current_user.id)
    @boards_options = boards.map { |board| [board.name, board.id] }
  end

  def update
    @board = Board.find_by(hash_id: params[:board_id])
    @log = Log.find_by(hash_id: params[:id])

    respond_to do |format|
      format.json {
        if @log.update(log_params)
          redirect_to board_log_path(@board, @log)
        else
          render json: {
            message: "User couldn't be created successfully."
          }, status: :unprocessable_entity
        end
      }
      format.html {
        if @log.update(log_params)
          redirect_to board_path(@board)
        else
          render 'edit'
        end
      }
    end
  end

  def publish
    @board = Board.find_by(hash_id: params[:board_id])
    @log = @board.logs.find_by(hash_id: params[:id])

    if @log.publish!
      subdomain = generate_subdomain(@log)
      protocol = request.protocol # "http://" or "https://"
      host_with_port = request.host_with_port # "mydomain.com:3000" or "mydomain.com"
      full_url = "#{protocol}#{subdomain}.#{host_with_port}"

      @site = @log.build_site(
        name: "#{@log.title}", 
        subdomain: subdomain,
        log_id: @log.id
      )
      
      if @site.save
        redirect_to board_log_path(@board, @log), notice: "Log published and site created successfully. #{full_url}"
      else
        redirect_to board_log_path(@board, @log), alert: "Log published but failed to create site."
      end
    else
      redirect_to board_log_path(@board, @log), alert: "Failed to publish the log."
    end
  end
  
  def destroy
    @log = Log.find_by(hash_id: params[:id])
    @log.destroy
    # LogMailer.deleted_log(@log).deliver_now
    respond_to do |format|
      format.json {
        render json: {
          status: 204,
          message: "Log deleted succesfully"
        }, status: 204
      }
      format.html {
        redirect_to board_path(@board)
      }
    end
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
    def generate_subdomain(log)
      # You can customize this logic to generate a unique subdomain
      "#{log.title.parameterize}-#{SecureRandom.hex(4)}"
    end

  private
    def log_params
      params.require(:log).permit(:title, :text, :tag_list, :board_id, :search, :is_private, :bluried, :color)
    end
end
