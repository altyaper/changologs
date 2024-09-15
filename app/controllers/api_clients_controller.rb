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

  def regenerate
    @api_client = current_user.api_clients.find(params[:id])
    @api_client.generate_credentials # Custom method to regenerate the key
    if @api_client.save
      redirect_to profile_path, notice: """
      API key regenerated successfully.
      New Secret Key: #{@api_client.client_secret}
      Save it in a secure place
      """
    else
      redirect_to profile_path, alert: 'Failed to regenerate API key.'
    end
  end

  private

  def api_client_params
    params.require(:api_client).permit(:name)
  end
end