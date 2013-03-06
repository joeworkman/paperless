require 'appscript'
include Appscript

module PaperlessOCR

  PDFPENPRO = 'PDFpenPro'

	class PDFpenPro
		def initialize
      @engine = PaperlessOCR::PDFPENPRO
      @app = app(@engine)
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
      rescue 
        puts "WARNING: There was an error OCRing the document with #{@engine}: #{$!}"
      end
    end

  end
end