require 'appscript'

module Paperless
  module OCR
    class PDFpenPro6
      include Appscript

      IDENTIFIER = 'pdfpenpro6'
      OSX_APP_NAME = 'PDFpenPro 6.app'

      def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
      end

      def ocr(options)
        begin
          doc = @app.open MacTypes::Alias.path(options[:file])
          doc.ocr

          app("System Events").processes['PDFpenPro 6'].visible.set(false)

          while doc.performing_ocr.get
            sleep 1
          end
          doc.close(:saving => :yes)
          sleep 3
        rescue 
          puts "WARNING: There was an error OCRing the document with #{OSX_APP_NAME}: #{$!}"
        end
      end
    end
  end
end
