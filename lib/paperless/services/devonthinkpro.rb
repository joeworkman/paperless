require 'appscript'
require 'fileutils'

module Paperless
  module Services
    class DevonThinkPro
      include Appscript
      include FileUtils

      IDENTIFIER = 'devonthinkpro'
      OSX_APP_NAME = 'DEVONthink Pro'

      def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
      end

      def create(options)
        destination = options[:destination]
        date        = options[:date]
        from_file   = options[:file]
        title       = options[:title] || File.basename(from_file)
        tags        = options[:tags].collect!{|x| x="'#{x}'"} # Add quotes around each tag in case there is a space

        time = Time.new(date.year, date.month, date.day)
        FileUtils.touch from_file, :mtime => time

        if tags.length > 0
          # Add open meta tags to file
          system("#{OPENMETA} -p '#{from_file}' -a #{tags.join(' ')}")
        end

        # Extract the database and folder name from the destination
        matches     = destination.match(/(.+)::(.+)/)
        dt_database = matches[1]
        dt_folder   = matches[2]

        unless dt_folder && dt_database
          raise "Unable to determine database and folder for DevonThinkPro: #{destination}"
        end

        db_conn = @app.open_database(dt_database)

        app("System Events").processes[OSX_APP_NAME].visible.set(false)

        group = @app.create_location(dt_folder, {:in => db_conn})
        @app.import(from_file, {:to => group, :name => title} )

        if options[:delete]
          FileUtils.rm from_file, :force => true
        end
      end
    end
  end
end
