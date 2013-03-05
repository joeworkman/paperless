require 'date'

module Paperless

	class DateSearch

		SEP = '\. \/\-\,'
		DAY = '(\d{1,2})'
		MONTH = '([a-zA-Z]{3,15})'
		YEAR = '(\d{4}|\d{2})'
		END_DATE = '(\s|$)'

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
				new_string += letter unless letter == prev && letter.match(/[a-z][A-Z]/)
				prev = letter
			}
			new_string
		end

		def date_search(text)
			date = nil
			if match = text.match(/#{MONTH}[#{SEP}]{0,3}#{DAY}[#{SEP}]{1,3}#{YEAR}#{END_DATE}/i)
				# December 29, 2011
				if valid_day(match[2]) && valid_year(match[3])
					puts "Basing the date off the discovered string (1): #{match[0]}"
					begin
						date = DateTime.parse(repair_ocr_string(match[0]))
					rescue
						puts "WARNING: Unable to create date object. #{$!}"
						date = nil
					end
				end
			elsif match = text.match(/#{DAY}[#{SEP}]{0,3}#{MONTH}[#{SEP}]{0,3}#{YEAR}#{END_DATE}/i)
				# 29 December 2011
				if valid_day(match[1]) && valid_year(match[3])
					puts "Basing the date off the discovered string (2): #{match[0]}"
					begin
						date = DateTime.parse(repair_ocr_string(match[0]))
					rescue
						puts "WARNING: Unable to create date object. #{$!}"
						date = nil
					end
				end
			elsif match = text.match(/#{DAY}[#{SEP}]+#{DAY}[#{SEP}]+#{YEAR}#{END_DATE}/)
				# US:   12-29-2011
				# Euro: 29-12-2011
				if @date_locale == 'us'
					if valid_month(match[1]) && valid_day(match[2]) && valid_year(match[3])
						puts "Basing the date off the discovered string (3): #{match[0]}"
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
						puts "Basing the date off the discovered string (4): #{match[0]}"
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

	end

end
