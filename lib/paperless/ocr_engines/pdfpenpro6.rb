require 'appscript'
include Appscript

module PaperlessOCR

  PDFPENPRO6 = 'PDFpenPro 6.app'

	class PDFpenPro6
		def initialize
      @engine = PaperlessOCR::PDFPENPRO6
      @app = app(@engine)
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
        puts "WARNING: There was an error OCRing the document with #{@engine}: #{$!}"
      end
    end

  end
end