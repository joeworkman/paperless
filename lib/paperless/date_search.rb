require 'date'

module DateSearch

	SEP = '\. \/\-\,'
	DAY = '(\d{1,2})'
	MONTH = '([a-zA-Z]{3,15})'
	YEAR = '(\d{4}|\d{2})'
	END_DATE = '(\s|$)'

	def valid_day(num)
		day = num.to_i
		return day <= 31 ? day : nil;
	end

	def valid_month(num)
		month = num.to_i
		return month <= 12 ? month : nil;
	end

	def valid_year(num)
		year = num.to_i
		now = DateTime.now

		if year < 100
      #transform 2 digit date into 4 digit date
			now_two_digit_year = now.year - 2000
			# In the 1900s? Need to add 1900. Else add 2000
			year += year > now_two_digit_year ? 1900 : 2000
		end

    # No file can have a date prior to 1970
		return year > 1970 && year <= now.year ? year : nil;
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

	def date_search(text,date_locale)
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
			year  = valid_year(match[3])
			day   = date_locale == 'us' ? valid_day(match[2])   : valid_day(match[1])
			month = date_locale == 'us' ? valid_month(match[1]) : valid_month(match[2])
			
			if month && day && year
				puts "Basing the date off the discovered string (3): #{match[0]}"
				begin
					date = DateTime.new(year,month,day)
				rescue
					puts "WARNING: Unable to create date object. #{$!}"
					date = nil
				end
			else
				puts "WARNING: The discovered date string does not validate: #{match[0]}"						
			end
		end
		date
	end

end
