class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :first_name, :last_name, :profile_picture])
  end

  def respond_with(current_user, _opts = {})
    respond_to do |format|
      format.json {
        if resource.persisted?
          render json: {
            status: {code: 200, message: 'Signed up successfully.'},
            data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
          }
        else
          render json: {
            status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
          }, status: :unprocessable_entity
        end
      }
      format.html {
        super
      }
    end
  end
  
end
