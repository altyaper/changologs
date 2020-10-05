class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @friend_request = FriendRequest.new
  end

  def create
    @friend_request = FriendRequest.new
    @friend_request.requestor_id = current_user.id
    @friend_request.receiver_id = params[:userId]
    
    if @friend_request.save!
      render json: {friend_request: @friend_request}
    else
      render status: 500, json: { error: "Could'nt make the friend request"}
    end
  end

end
