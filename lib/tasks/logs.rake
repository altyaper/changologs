namespace :logs do
  desc "Move is_private values into bluried values"
  task private_to_bluried: :environment do
    Log.all.each do |log|
      log.bluried = log.is_private
      log.is_private = true;
      log.save!
    end
  end
end
