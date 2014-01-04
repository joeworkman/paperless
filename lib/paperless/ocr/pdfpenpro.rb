require 'appscript'

module Paperless
  module OCR
    class PDFpenPro
      include Appscript

      IDENTIFIER = 'pdfpenpro'
      OSX_APP_NAME = 'PDFpenPro'

      def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
      end

      def ocr(options)
        begin
          doc = @app.open MacTypes::Alias.path(options[:file])
          doc.ocr

          app("System Events").processes[OSX_APP_NAME].visible.set(false)

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
