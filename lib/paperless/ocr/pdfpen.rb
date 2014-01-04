require 'appscript'

module Paperless
  module OCR
    class PDFpen
      include Appscript

      ENGINE_NAME = 'pdfpen'
      OSX_APP_NAME = 'PDFpen' 

      def initialize
        @app = app(OSX_APP_NAME)
        @app.activate
      end

      def ocr(options)
        begin
          doc = @app.open MacTypes::Alias.path(options[:file])
          doc.ocr

          app("System Events").processes[@engine].visible.set(false)

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
