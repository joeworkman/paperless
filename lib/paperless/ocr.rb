require 'paperless/ocr/acrobat.rb'
require 'paperless/ocr/pdfpen6.rb'
require 'paperless/ocr/pdfpenpro6.rb'
require 'paperless/ocr/pdfpen.rb'
require 'paperless/ocr/pdfpenpro.rb'
require 'paperless/ocr/devonthinkpro.rb'

module Paperless
   class OCREngine 
    CLASSES = [
      Paperless::OCR::PDFpenPro6,
      Paperless::OCR::PDFpen6,
      Paperless::OCR::PDFpenPro,
      Paperless::OCR::PDFpen,
      Paperless::OCR::AdobeAcrobatPro,
      Paperless::OCR::DevonThinkPro
    ]

    def self.apply(identifier)
      CLASSES.detect { |klass| (identifier =~ /^#{klass::IDENTIFIER}$/i) }
    end
  end
end
