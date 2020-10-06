class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(current_user.id)
  end

  def search_friends
    return [] if (query = params[:q]).nil?

    id = current_user.id
    user_ids = FriendRequest
                  .where('requestor_id = ? OR receiver_id = ?', id, id)
                  .pluck(:requestor_id, :receiver_id)
                  .flatten
                  .uniq
    users = User.search(query, id).where.not(id: user_ids)
    render json: users
  end

end
