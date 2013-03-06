require 'appscript'
include Appscript

module PaperlessOCR

  ACROBAT = 'Adobe Acrobat Pro'

  class PDFpen
    def initialize
      @engine = PaperlessOCR::ACROBAT
      @app = app(@engine)
      @app.activate
    end

    def ocr(options)

      begin

      rescue 
        puts "WARNING: There was an error OCRing the document with #{@engine}: #{$!}"
      end
    end

  end
end

__END__

The Following does not work with Acrobat X

tell application "Adobe Acrobat Professional"
      activate
      open theFile
      tell application "System Events"
         tell process "Acrobat"
            tell menu bar 1
               tell menu "Document"
                  tell menu item "OCR Text Recognition"
                     tell menu 1
                        click menu item "Recognize Text Using OCR..."
                     end tell
                  end tell
               end tell
 
            end tell
            keystroke return
         end tell
      end tell
      save the front document
      close the front document
   end tell