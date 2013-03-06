require 'appscript'
include Appscript

module PaperlessOCR

  PDFPEN = 'PDFpen'

	class PDFpen
		def initialize
      @engine = PaperlessOCR::PDFPEN
      @app = app(@engine)
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
      rescue 
        puts "WARNING: There was an error OCRing the document with #{@engine}: #{$!}"
      end
    end

  end
end