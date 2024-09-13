class ApiClientsController < ApplicationController
  before_action :authenticate_client_or_user!

  def index
    @api_clients = @user.api_clients
  end

  def new
    @api_client = ApiClient.new
  end

  def create
    @user = current_user
    @api_client = current_user.api_clients.build(api_client_params)
    if @api_client.save
      redirect_to profile_path, notice: 'API client created successfully.'
    else
      render profile_path
    end
  end

  private

  def api_client_params
    params.require(:api_client).permit(:name)
  end
end