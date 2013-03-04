require 'appscript'
include Appscript

module PaperlessOCR

  PDFPENPRO = 'PDFpenPro'

	class PDFpenPro
		def initialize(options)
			@file = options[:file]
      @minimize = options[:minimize]||false
      @engine = PaperlessOCR::PDFPENPRO
      @app = app(@engine)
		end

    def ocr
      begin
        doc = @app.open MacTypes::Alias.path(@file)
        doc.ocr

        if @minimize
          sys = app("System Events")
          sys.application_processes[@engine].windows[1].buttons[its.role_description.eq("minimize button")].buttons[1].click
        end

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