require 'appscript'
include Appscript
require 'pdf/reader'
require 'date'

module Paperless

  PDF_EXT = 'pdf'
  DATE_VAR = '<date>'
  MATCH_VAR = '<match>'
  FILEDATE = 'filedate'

	class Engine

		SEP = '\.\s\/\-\,'
		DAY = '(\d{1,2})'
		MONTH = '(\w{3,15})'
		YEAR = '(\d{4}|\d{2})'
		END_DATE = '(\s+|$)'

		def initialize(options)
			@notebook = nil
			@title 		= nil
			@date 		= nil
			@tags			= Array.new()

	    @file     = options[:file]
      @text_ext = options[:text_ext]
      @html_ext = options[:html_ext]
      @service = options[:service]
      @date_format = options[:date_format]
      @date_locale = options[:date_locale]
      @date_default = options[:date_default]
      @default_notebook = options[:default_notebook]
      @pdf_ext  = [Paperless::PDF_EXT]
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
			unless tags.length
				@tags = (@tags + tags).collect {|x| x.downcase }
				@tags.uniq!
			end
		end

		def set_notebook(notebook)
			@notebook = notebook if notebook && @notebook.nil?
			#check it notebook exists
		end

		def set_title(title)
			@title = title if title && @title.nil?
		end

		def set_service(service)
			@service = service if service && @service.nil?
		end

		def valid_day(num)
			day = num.to_i
			return day <= 31 ? true : false;
		end

		def valid_month(num)
			month = num.to_i
			return month <= 12 ? true : false;
		end

		def valid_year(num)
			year = num.to_i
			now = DateTime.now
			return (year > 1970 && year <= now.year) || year < 100 ? true : false;
		end

		def repair_ocr_string(string)
			string.downcase!
			prev = ''
			new_string = ''

			# I noticed that letters tend to get duplicated during OCR. This tries to fix that.
			# This only looks at letters since numbers could be duplicated
			string.each_char {|letter|
				new_string += letter unless letter == prev && letter.match(/[a-z]/)
				prev = letter
			}
			new_string
		end

		def date_search(text)
			date = nil
			if match = text.match(/#{MONTH}[#{SEP}]+#{DAY}[#{SEP}]+#{YEAR}/)
				# December 29, 2011
				if valid_day(match[2]) && valid_year(match[3])
					puts "Basing the date off the discovered string: #{match[0]}"
					begin
						date = DateTime.parse(repair_ocr_string(match[0]))
					rescue
						puts "WARNING: Unable to create date object. #{$!}"
						date = nil
					end
				end
			elsif match = text.match(/#{DAY}[#{SEP}]+#{MONTH}[#{SEP}]+#{YEAR}/)
				# 29 December 2011
				if valid_day(match[1]) && valid_year(match[3])
					puts "Basing the date off the discovered string: #{match[0]}"
					begin
						date = DateTime.parse(repair_ocr_string(match[0]))
					rescue
						puts "WARNING: Unable to create date object. #{$!}"
						date = nil
					end
				end
			elsif match = text.match(/#{DAY}[#{SEP}]+#{DAY}[#{SEP}]+#{YEAR}/)
				# US:   12-29-2011
				# Euro: 29-12-2011
				if @date_locale == 'us'
					if valid_month(match[1]) && valid_day(match[2]) && valid_year(match[3])
						puts "Basing the date off the discovered string: #{match[0]}"
						begin
							date = DateTime.new(match[3].to_i,match[1].to_i,match[2].to_i)
						rescue
							puts "WARNING: Unable to create date object. #{$!}"
							date = nil
						end
					else
						puts "WARNING: The discovered date string does not validate: #{match[0]}"						
					end
				else
					if valid_day(match[1]) && valid_month(match[2]) && valid_year(match[3])
						puts "Basing the date off the discovered string: #{match[0]}"
						begin
							date = DateTime.new(match[3].to_i,match[2].to_i,match[1].to_i)
						rescue
							puts "WARNING: Unable to create date object. #{$!}"
							date = nil
						end
					end
				end
			end
			date
		end

		def process_pdf
			puts "Processing PDF pages..."

		  reader = PDF::Reader.new(@file)

		  # Verify that we need to search for date or just set to today
		  # Need to prcess file for date in case the rules need to use it.
		  # First check if there are actually any date rules
      @rules.each do |rule|
			  if rule.condition == Paperless::DATE_VAR
			    reader.pages.each do |page|
			    	@date = self.date_search(page.text)
			    	break unless @date.nil?
			    end
			    break
	    	end
			end
	    if @date.nil?
	    	puts "Using default date..."
	    	# Set the default date to the date of the file or else to now
	    	if @date_default == Paperless::FILEDATE
	    		t = File.stat(@file).ctime
	    		@date = Date.new(t.year,t.month,t.day) 
	    	else
	    		@date = DateTime.now
	    	end
	    end

	    return

			# Process each page and pass it through the rules engine
	    reader.pages.each do |page|
	      @rules.each do |rule|
	      	rule.set_date(@date,@date_default)
	      	if !rule.matched && rule.match(@file, page.text)
	      		self.add_tags(rule.tags)
	      		self.set_notebook(rule.notebook)
	      		self.set_title(rule.title)
	      		self.set_service(rule.service)
	      	end
	      end
	    end
		end

		def ocr
			puts "Running OCR on file with #{@ocr_engine}"
      ocr_engine = case @ocr_engine
        when /^pdfpenpro$/i then PaperlessOCR::PDFpenPro.new({:file => @file})
        when /^pdfpen$/i then PaperlessOCR::PDFpen.new({:file => @file})
        when /^acrobat$/i then PaperlessOCR::Acrobat.new({:file => @file})
        else false
      end
      
      if ocr_engine
        ocr_engine.ocr 
      else
        puts "WARNING: No valid OCR engine was defined."
      end
		end

		def create
			self.print
      # :created => @date
      service_options = { :notebook => @notebook, :from_file => MacTypes::FileURL.path(@file), :title => @title, :tags => @tags }

      service = case @service
        when /^evernote$/i then PaperlessService::Evernote.new(service_options)
        when /^finder$/i then PaperlessService::Finder.new(service_options)
        when /^devonthink$/i then PaperlessService::DevonThink.new(service_options)
        else false
      end

      if service
        service.create
      else
        puts "WARNING: No valid Service was defined."
      end
		end

		def print
			notebook = @notebook.nil? ? @default_notebook : @notebook
			title = @title.nil? ? File.basename(@file) : @title

			puts "File: #{@file}"
			puts "Notebook: #{notebook}"
			puts "Title: #{title}"
			puts "Date: #{@date.to_s}"
			puts "Tags: #{@tags.join(',')}"
		end

	end

end
