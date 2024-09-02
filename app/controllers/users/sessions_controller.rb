class Users::SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    # Authenticate user with just email and password.
    self.resource = warden.authenticate!(auth_options.merge(strategy: :password_authenticatable))
    if resource && resource.active_for_authentication?
      # If the user has 2FA enabled
      if resource.otp_required_for_login
        # Store the user ID temporarily. We're not saving the password in the session for security reasons.
        # Generate a signed token for the user ID.
        verifier = Rails.application.message_verifier(:otp_session)
        token = verifier.generate(resource.id)
        session[:otp_token] = token

        # Logout the user to wait for the 2FA verification
        sign_out(resource_name)

        # Redirect the user to the OTP entry page
        redirect_to user_otp_path and return
      else
        # If 2FA is not required, log the user in
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource) and return
      end
    end

    # If user authentication failed
    flash[:alert] = 'Invalid email or password.'
    redirect_to new_user_session_path
  end

    private
  def respond_with(current_user, _opts = {})
    respond_to do |format|
      format.json {
        render json: {
          status: { 
            code: 200, message: 'Logged in successfully.',
            data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
          }
        }, status: :ok
      }
      format.html {
          super
      }
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key || ENV['SECRET_KEY_BASE']).first
      current_user = User.find(jwt_payload['sub'])
    end

    respond_to do |format|
      format.json {
        if current_user
          render json: {
            status: 200,
            message: 'Logged out successfully.'
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
      }
      format.html {
        super
      }
    end
    
  end
end
