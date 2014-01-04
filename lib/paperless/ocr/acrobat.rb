require 'appscript'

module Paperless
  module OCR
    class AdobeAcrobatPro 
      include Appscript

      IDENTIFIER = 'acrobat'
      OSX_APP_NAME = 'Adobe Acrobat Pro'

      def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
      end

      def ocr(options)
        begin
        rescue 
          puts "WARNING: There was an error OCRing the document with #{OSX_APP_NAME}: #{$!}"
        end
      end
    end
  end
end
