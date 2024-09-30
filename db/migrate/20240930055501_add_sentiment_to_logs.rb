class AddSentimentToLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :logs, :sentiment, :string
  end
end
