class WelcomeController < ApplicationController
  def index
    @logs = Log.all
  end
end
