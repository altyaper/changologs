class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_client_or_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password)}
  end

  private

  # This method will try to authenticate either an API client or a regular user
  def authenticate_client_or_user!
    if request.headers['Client-Id'].present? && request.headers['Client-Secret'].present?
      authenticate_client!
    else
      authenticate_user!  # Devise's method for authenticating users (JWT/session)
      @user = current_user
    end
  end

  def authenticate_client!
    client_id = request.headers['Client-Id'] || params[:client_id]
    client_secret = request.headers['Client-Secret'] || params[:client_secret]

    @api_client = ApiClient.find_by(client_id: client_id, client_secret: client_secret)
    
    if @api_client
      @user = @api_client.user  # This gives you access to the associated user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
