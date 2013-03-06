require 'fileutils'
include FileUtils

module PaperlessService

  FINDER = 'Finder'

	class Finder

    NO_MOVE = '<nomove>'

		def initialize
      @app = app(PaperlessService::FINDER)
      @app.activate
		end

    def create(options)
      destination = options[:destination]
      date        = options[:date]
      from_file   = options[:file]
      title       = options[:title]
      tags        = options[:tags].collect!{|x| x="'#{x}'"} # Add quotes around each tag in case there is a space

      if destination == NO_MOVE || destination == File.dirname(from_file)
        new_filename = File.join(File.dirname(from_file), title + File.extname(from_file))
      else
        FileUtils.mkdir_p destination unless File.exists?(destination)
        new_filename = File.join(destination, title + File.extname(from_file))
      end

      FileUtils.mv from_file, new_filename, :force => true

      time = Time.new(date.year, date.month, date.day)
      FileUtils.touch new_filename, {:mtime => time}

      if tags.length > 0
        # Add open meta tags to file
        system("#{OPENMETA} -p '#{new_filename}' -a #{tags.join(' ')}")
      end
    end

	end
end