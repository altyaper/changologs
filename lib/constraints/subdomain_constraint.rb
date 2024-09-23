class SubdomainConstraint
  def matches?(request)
    byebug
    Site.where(subdomain: request.subdomain).exist?
  end
end