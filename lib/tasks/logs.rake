namespace :logs do
  desc "Move is_private values into bluried values"
  task private_to_bluried: :environment do
    Log.all.each do |log|
      log.bluried = log.is_private
      log.is_private = true;
      log.save!
    end
  end

  task add_sentiment_to_logs: :environment do
    Sentimental.load_defaults
    analyzer = Sentimental.new

     # Iterate over all logs and update their sentiment
     Log.find_each do |log|
      # Analyze the sentiment of each log's text
      sentiment_score = analyzer.sentiment(log.text).to_s

      # Update the sentiment column
      log.update_column(:sentiment, sentiment_score)

      puts "Updated log ##{log.id} with sentiment: #{sentiment_score}"
    end
  end
end
