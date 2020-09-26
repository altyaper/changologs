class LogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @logs = Log.all
  end
  
  def new
    @log = Log.new
  end

  def edit
    @log = Log.find(params[:id])
  end

  def update
    @log = Log.find(params[:id])
   
    if @log.update(log_params)
      redirect_to @log
    else
      render 'edit'
    end
  end

  def destroy
    @log = Log.find(params[:id])
    @log.destroy!
 
    redirect_to logs_path
  end

  def create
    @log = Log.create(log_params)
    if @log.save!
      redirect_to @log
    else
      render 'new'
    end
  end

  def show
    @log = Log.find(params[:id])
  end

  private
    def log_params
      params.require(:log).permit(:title, :text)
    end
end
