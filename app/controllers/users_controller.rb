class UsersController < ApplicationController
  before_action :authenticate_client_or_user!, except: %i[show_otp verify_otp]

  def disable_otp
    # current_user.otp_required_for_login = false
    # current_user.save!
    # redirect_to root_path

    # Preferred approach, something like this:
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.otp_required_for_login = false
      current_user.save!
      redirect_to root_path, notice: 'Two-factor authentication disabled successfully.'
    else
      flash[:alert] = 'Invalid OTP code.'
      redirect_back(fallback_location: root_path)
    end
  end

  def show_otp
    # Render the OTP entry page
  end

  def verify_otp
    verifier = Rails.application.message_verifier(:otp_session)
    user_id = verifier.verify(session[:otp_token])
    user = User.find(user_id)

    if user.validate_and_consume_otp!(params[:otp_attempt])
      # OTP is correct. Log the user in
      sign_in(:user, user)
      redirect_to root_path, notice: 'Logged in successfully!'
    else
      flash[:alert] = 'Invalid OTP code.'
      # Send them back to the sign in page, but don't show them the OTP entry page again.
      # This is because we don't want the user to know whether the OTP code was invalid
      # because they didn't fill out the form correctly, or if the OTP code was just wrong.
      redirect_to new_user_session_path
    end
  end

  def enable_otp_show_qr
    if current_user.otp_required_for_login
      redirect_to edit_user_registration_path, alert: '2FA is already enabled.'
    else
      current_user.otp_secret = User.generate_otp_secret
      issuer = 'Your App'
      label = "#{issuer}:#{current_user.email}"

      @provisioning_uri = current_user.otp_provisioning_uri(label, issuer:)
      current_user.save!
    end
  end

  def enable_otp_verify
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.otp_required_for_login = true
      current_user.save!
      redirect_to edit_user_registration_path, notice: '2FA enabled successfully.'
    else
      redirect_to enable_otp_show_qr_path, alert: 'Invalid OTP code.'
    end
  end

  def show
    @user = User.find(current_user.id)
    respond_to do |format|
      format.json {
        render json: {
          status: 200,
          data: UserSerializer.new(@user).serializable_hash[:data][:attributes]
        }, status: :ok
      }
      format.html {}
    end
  end

  def search_friends
    respond_to do |format|
      format.json {
        users = []
        if !params[:q].nil?
          query = params[:q]
          id = current_user.id
          user_ids = FriendRequest
                      .where('requestor_id = ? OR receiver_id = ?', id, id)
                      .pluck(:requestor_id, :receiver_id)
                      .flatten
                      .uniq
          users = User.search(query, id).where.not(id: user_ids)
        end
        render json: users
      }
    end

  end

  def show
    @user = current_user
    @api_client = ApiClient.new
    @api_clients = @user.api_clients
  end
end
