class FriendshipController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def friendship
    friendship = Friendship.new
    friendship.friend_a_id = current_user.id
    friendship.friend_b_id = params[:userId]
    friend_request = FriendRequest
      .where('requestor_id = ? AND receiver_id = ?', params[:userId], current_user.id).first
    
    if friend_request.destroy!
      if friendship.save!
        render json: friendship
      else
        render status: 403, json: { error: 'Invalid friendship'}
      end
    end
  end
end
