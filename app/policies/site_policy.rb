class SitePolicy < ApplicationPolicy
  def show?
    true  # Allow public access to the show action, no authentication needed
  end
end