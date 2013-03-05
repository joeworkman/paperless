require 'pdf/reader'

module Paperless

  PDF_EXT = 'pdf'
  DATE_VAR = '<date>'
  MATCH_VAR = '<match>'
  FILEDATE = 'filedate'
  TODAY = 'today'

	class Engine

		def initialize(options)
      @destination = nil
			@title 		= nil
			@date 		= nil
			@tags			= Array.new()

	    @file     = options[:file]
      @text_ext = options[:text_ext]
      @html_ext = options[:html_ext]
      @pdf_ext  = [Paperless::PDF_EXT]
      @service = options[:service]
      @date_format = options[:date_format]
      @date_locale = options[:date_locale]
      @date_default = options[:date_default]
      @default_destination = options[:default_destination]
      @rules 		= Array.new()

			options[:rules].each do |rule|
				@rules.push Paperless::Rule.new(rule)
			end

      @ocr_engine = options[:ocr_engine]||false
		end

		def process_rules
			text_ext = @text_ext + @html_ext
			file_ext = File.extname(@file).gsub(/\./,'')

			if file_ext == Paperless::PDF_EXT
        
        self.process_pdf

      elsif text_ext.index file_ext

        self.process_text
      
      else
      	puts "Unknown file type. No rules were processed."
      end
		end

		def add_tags(tags)
			if tags.length > 0
				@tags = (@tags + tags).collect {|x| x = x.downcase }
				@tags.uniq!
			end
		end

		def set_destination(destination)
      # TODO: check it destination exists
			@destination = destination if destination && @destination.nil?
		end

		def set_title(title)
			@title = title if title && @title.nil?
		end

		def set_service(service)
			@service = service if service && @service.nil?
		end

    def set_date_default()
      puts "Using default date..."
      # Set the default date to the date of the file or else to now
      if @date_default == Paperless::FILEDATE
        t = File.stat(@file).ctime
        @date = Date.new(t.year,t.month,t.day) 
      else
        @date = DateTime.now
      end
    end

		def process_pdf
			puts "Processing PDF pages..."

		  reader = PDF::Reader.new(@file)
      ds = Paperless::DateSearch.new

		  # Verify that we need to search for date or just set to today
		  # Need to prcess file for date in case the rules need to use it.
		  # First check if there are actually any date rules
      @rules.each do |rule|
			  if rule.condition == Paperless::DATE_VAR
			    reader.pages.each do |page|
			    	break if @date = ds.date_search(page.text)
			    end
			    break
	    	end
			end
	    self.set_date_default if @date.nil?

			# Process each page and pass it through the rules engine
	    reader.pages.each do |page|
	      @rules.each do |rule|
	      	rule.set_date(@date,@date_format)
	      	if !rule.matched && rule.match(@file, page.text)
	      		self.add_tags(rule.tags)
	      		self.set_destination(rule.destination)
	      		self.set_title(rule.title)
	      		self.set_service(rule.service)
	      	end
	      end
	    end
		end

		def ocr
			puts "Running OCR on file with #{@ocr_engine}"
      ocr_engine = case @ocr_engine
        when /^pdfpenpro$/i then PaperlessOCR::PDFpenPro.new
        when /^pdfpen$/i then PaperlessOCR::PDFpen.new
        when /^acrobat$/i then PaperlessOCR::Acrobat.new
        else false
      end
      
      if ocr_engine
        ocr_engine.ocr({:file => @file})
      else
        puts "WARNING: No valid OCR engine was defined."
      end
		end

		def create
			self.print

      # May need to externalize this so other methods can access it.
      service = case @service
        when /^evernote$/i then PaperlessService::Evernote.new
        when /^finder$/i then PaperlessService::Finder.new
        when /^devonthink$/i then PaperlessService::DevonThink.new
        else false
      end

      if service
        destination = @destination.nil? ? @default_destination : @destination
        # :created => @date
        service.create({ :destination => destination, :from_file => MacTypes::FileURL.path(@file), :title => @title, :tags => @tags })
      else 
        puts "WARNING: No valid Service was defined."
      end
		end

		def print
      destination = @destination.nil? ? @default_destination : @destination
			title = @title.nil? ? File.basename(@file) : @title

			puts "File: #{@file}"
			puts "Destination: #{destination}"
			puts "Title: #{title}"
			puts "Date: #{@date.to_s}"
			puts "Tags: #{@tags.join(',')}"
		end

	end

end
