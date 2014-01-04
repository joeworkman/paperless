require 'appscript'
require 'fileutils'
require 'markdown'

module Paperless
  module Services
  	class Evernote
      include Appscript
      include FileUtils

      IDENTIFIER = 'evernote'
      OSX_APP_NAME = 'Evernote'

  		def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
  		end

      def create(options)
        destination = options[:destination]
        date        = options[:date]
        from_file   = options[:file]
        title       = options[:title] || File.basename(from_file)
        tags        = options[:tags]
        text_ext    = options[:text_ext]

        create_options = { :created => date }
        file_ext = File.extname(from_file)
        file_dir = File.dirname(from_file)
        file_name = File.basename(from_file)

        if file_name != title
          new_filename = File.join(file_dir, title + file_ext)
          File.rename(from_file, new_filename)
          from_file = new_filename
        end

        if text_ext.index file_ext.gsub!(/\./,'')
          puts "Adding text note into Evernote"
          create_options[:with_text] = File.open(from_file, "rb") {|io| io.read}
        else
          if file_ext.match(/md$/i)
            # If this is a mardown file insert it into Evernote as html
            puts "Converting Markdown to HTML"
            text = File.open(from_file, "rb") {|io| io.read}
            create_options[:with_html] = Markdown.new(text).to_html
          else
            # Create a note from a file and let Evernote choose how to attach the file
            puts "Adding note into Evernote"
            create_options[:from_file] = MacTypes::FileURL.path(from_file)
          end
        end

        create_options[:tags] = tags if tags.length > 0
        create_options[:notebook] = destination if destination

        @app.create_note(create_options)

        if options[:delete]
          FileUtils.rm from_file, :force => true
        end

        @app.synchronize
      end
    end
	end
end
