require 'fileutils'
include FileUtils
require 'markdown'
require 'appscript'
include Appscript

module PaperlessService

  EVERNOTE = 'Evernote'

	class Evernote

		def initialize
      @app = app(PaperlessService::EVERNOTE)
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
      file_ext = File.extname(from_file.gsub(/\./,''))

      if text_ext.index file_ext
        create_options[:with_text] = File.open(from_file, "rb") {|io| io.read}
      else
        if file_ext.match(/md$/i)
          # If this is a mardown file insert it into Evernote as html
          text = File.open(from_file, "rb") {|io| io.read}
          create_options[:with_html] = Markdown.new(text).to_html
        else
          # Create a note from a file and let Evernote choose how to attach the file
          create_options[:from_file] = MacTypes::FileURL.path(from_file)
        end
      end

      create_options[:tags] = tags if tags.length > 0
      create_options[:notebook] = destination if destination

      @app.create_note(create_options)

      if options[:delete]
        FileUtils.rm from_file, :force => true
      end
    end

	end
end