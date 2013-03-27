require 'appscript'
include Appscript

module PaperlessOCR

  PDFPEN6 = 'PDFpen 6.app'

	class PDFpen6
		def initialize
      @engine = PaperlessOCR::PDFPEN6
      @app = app(@engine)
      @app.activate
		end

    def ocr(options)
      begin
        doc = @app.open MacTypes::Alias.path(options[:file])
        doc.ocr

        app("System Events").processes['PDFpen 6'].visible.set(false)

        while doc.performing_ocr.get
          sleep 1
        end
        doc.close(:saving => :yes)
        sleep 3
      rescue 
        puts "WARNING: There was an error OCRing the document with #{@engine}: #{$!}"
      end
    end

  end
end