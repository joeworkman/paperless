require 'appscript'
require 'fileutils'

module Paperless
  module Services
  	class Finder
      include Appscript
      include FileUtils

      IDENTIFIER = 'finder'
      NO_MOVE = '<nomove>'
      OSX_APP_NAME = 'Finder'

  		def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
  		end

      def create(options)
        destination = options[:destination]
        date        = options[:date]
        from_file   = options[:file]
        title       = options[:title] || File.basename(from_file, File.extname(from_file))
        tags        = options[:tags].collect!{|x| x="'#{x}'"} # Add quotes around each tag in case there is a space

        if destination == NO_MOVE || destination == File.dirname(from_file)
          new_filename = File.join(File.dirname(from_file), title + File.extname(from_file))
          puts "New filename (1): #{new_filename}"
        else
          FileUtils.mkdir_p destination unless File.exists?(destination)
          new_filename = File.join(destination, title + File.extname(from_file))
          puts "New filename (2): #{new_filename}"
        end

        puts "Copying File..."
        FileUtils.cp from_file, new_filename, :verbose => true

        time = Time.new(date.year, date.month, date.day)
        puts "Modifying the time of the file to be #{time.to_s}"
        FileUtils.touch new_filename, {:mtime => time}

        if tags.length > 0
          # Add open meta tags to file
          puts "Tagging file"
          system("#{OPENMETA} -p '#{new_filename}' -a #{tags.join(' ')}")
        end

        if options[:delete] && from_file != new_filename
          puts "Removing original file"
          FileUtils.rm from_file, :force => true, :verbose => true
        end
      end
    end
	end
end
