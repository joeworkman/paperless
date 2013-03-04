require 'appscript'
include Appscript

module PaperlessService

  EVERNOTE = 'Evernote'

	class Evernote

		def initialize(options)
      @file     = options[:file]
      @notebook = options[:notebook]
      @title    = options[:title]
      @file     = options[:tags]

      @app = app(PaperlessService::EVERNOTE)
      @app.activate
		end

    def create
      @app.create_note(:notebook => @notebook, :from_file => MacTypes::FileURL.path(@file), :title => @title, :tags => @tags)
    end

	end
end