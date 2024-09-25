class SubdomainConstraint
  def matches?(request)
    Site.find_by(subdomain: request.subdomain)
  end
end