class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @logs = Log.all.where(user_id: current_user.id).order(created_at: :desc)
  end
end
