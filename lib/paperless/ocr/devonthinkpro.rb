require 'appscript'

module Paperless
  module OCR
    class DevonThinkPro
      include Appscript

      IDENTIFIER = 'devonthinkpro'
      OSX_APP_NAME = 'DEVONthink Pro'
      
      def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
      end

      def ocr(options)
        begin
          app("System Events").processes[OSX_APP_NAME].visible.set(false)
          @app.ocr(:file => options[:file])
        rescue 
          puts "WARNING: There was an error OCRing the document with #{OSX_APP_NAME}: #{$!}"
        end
      end
    end
  end
end
