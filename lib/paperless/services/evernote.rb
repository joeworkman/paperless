require 'appscript'
include Appscript

module PaperlessService

  EVERNOTE = 'Evernote'

	class Evernote

		def initialize(options)
      @app = app(PaperlessService::EVERNOTE)
      @app.activate
		end

    def create(options)
      @app.create_note(:notebook => options[:notebook], :from_file => MacTypes::FileURL.path(options[:file]), :title => options[:title], :tags => options[:tags])
    end

	end
end