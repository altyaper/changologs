Rails.application.config.after_initialize do
  # Ensure Site and ApplicationRecord are loaded after initialization
  Site.all.each do |site|
    Rails.application.config.hosts << "#{site.subdomain}.changologs.local"
  end
end