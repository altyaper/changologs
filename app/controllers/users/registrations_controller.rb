class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  before_action :configure_permitted_parameters, if: :devise_controller?


  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    redirect_to edit_registration_path(resource_name) and return if should_disable_otp? && !disable_otp!

    process_standard_update
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :profile_picture, :otp_attempt])
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
            status: {
              message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      }
      format.html {
        super
      }
    end
  end

  protected

  def should_disable_otp?
    resource.otp_required_for_login && params[:user][:otp_attempt].present? && params[:user][:current_password].present?
  end

  def disable_otp!
    otp_attempt = params[:user][:otp_attempt]
    current_password = params[:user][:current_password]

    if resource.validate_and_consume_otp!(otp_attempt) && resource.valid_password?(current_password)
      resource.otp_required_for_login = false
      resource.save!
      set_flash_message!(:notice, :otp_disabled)
      true
    else
      set_flash_message!(:alert, appropriate_error_message(otp_attempt, current_password))
      false
    end
  end

  def appropriate_error_message(otp_attempt, current_password)
    return :invalid_otp unless resource.validate_and_consume_otp!(otp_attempt)
    return :invalid_password unless resource.valid_password?(current_password)

    :invalid_otp_and_password
  end

  def process_standard_update
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  
end
