class UserBoardController < ApplicationController
    before_action :authenticate_user!
  
    def destroy
      relation = UserBoard.find_by(user_id: current_user.id)
      relation.destroy
      redirect_to root_path()
    end
  end
  