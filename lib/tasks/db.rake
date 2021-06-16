require 'ruby-progressbar'

namespace :db do
  desc "Pulls production data and dump it into our local database"
  task load: :environment do

    begin

      local = Database::Utilities::Local.new local_config
      production = Database::Utilities::Production.new remote_config
      
      puts "Generating dump file"
      # production.dump

      puts "Backing up local DB..."
      # local.dump

      puts "Removing local development DB..."
      local.drop

      puts "Importing DB from staging into local..."
      # local.load production.dump_file

    rescue Exception => e
      puts e
    end
  end

end

def local_config
  Rails.configuration.database_configuration[Rails.env].merge({dump_file: 'db/backups/development.sql'})
end

def remote_config
  remote_config_file = YAML.load_file(Rails.root.join('config/database.yml.production'))
  remote_config = remote_config_file['defaults'].merge({dump_file: production_file()})
end

def production_file
  Rails.root.join('db/backups/production.sql')
end

module Database
  module Utilities
    class Base
      attr_reader :dump_file

      def initialize(config)
        @config = escape_strings config
        @dump_file = Rails.root.join @config[:dump_file]
      end

      private
      def escape_strings(config)
        config.each do |key, value|
          config[key] = value.to_s.gsub("'", %q(\\\')) unless value.nil?
        end
      end

    end

    class Production < Base
      def dump
        system %(PGPASSFILE='./.pgpass' pg_dump -h '#{@config["host"]}' -U '#{@config["username"]}' '#{@config["database"]}' -f #{@dump_file})
      end
    end

    class Local < Base

      def terminate_active_postgres_sessions
        query = "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '#{@config["database"]}' AND pid <> pg_backend_pid();"
        system %(PGPASSWORD=#{@config["password"]} psql -U '#{@config["username"]}' -d '#{@config["database"]}' -c "#{query}" > /dev/null) # suppress noisy output
      end

      def dump
        system %(PGPASSWORD=#{@config["password"]} pg_dump -U '#{@config["username"]}' '#{@config["database"]}' -f #{@dump_file})
      end

      def drop
        terminate_active_postgres_sessions # Prevents ERROR: database "xx" is being accessed by other users
        system "bundle exec rake db:drop && rake db:create"
      end

      def load(backup_file)
        system %(PGPASSWORD=#{@config["password"]} psql -U '#{@config["username"]}' -d '#{@config["database"]}' -f #{backup_file})
      end
    end
  end
end
