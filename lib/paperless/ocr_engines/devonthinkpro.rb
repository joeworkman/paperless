require 'appscript'
include Appscript

module PaperlessOCR

  DEVONTHINKPRO = 'DEVONthink Pro'

	class DevonThinkPro
    
		def initialize
      @engine = PaperlessOCR::DEVONTHINKPRO
      @app    = app(@engine)
      @app.activate
		end

    def ocr(options)
      begin
        app("System Events").processes[@engine].visible.set(false)
        @app.ocr(:file => options[:file])
      rescue 
        puts "WARNING: There was an error OCRing the document with #{@engine}: #{$!}"
      end
    end

  end
end