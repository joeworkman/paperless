module Paperless

	class Rule

		def initialize(options)
			# @todo: Add logic to validate rule has proper settings

			@scope 		 = options['scope'].split
			@condition = options['condition']
			@destination  = options['destination']
			@service  = options['service']
			@title 		 = options['title']
			@date 		 = options['date']
			@description 		 = options['description']
			@tags			 = options['tags'].nil? ? Array.new : options['tags'].split
			@date_stamp = DateTime.now
			@date_default_format = '%Y-%m-%d'
			@matched   = false
		end

		attr_reader :matched, :tags, :destination, :condition, :title, :date, :service

		def set_date(date,format)
			@date_stamp = date
			@date_default_format = format
		end

		def match(file,text)
			return @matched if @matched

			if @condition == Paperless::DATE_VAR
				@date = date
				@matched = true
			else
				@scope.each do |type|
					case type
						when 'content' then
							self.match_text(text)
						when 'filename' then
							self.match_text(file)
						else
							puts "WARNING: Unknown scope defined - #{type}"
					end
				end
			end
			return @matched
		end

		def match_text(text)
			match = text.match(/#{@condition}/i) {|md| md[0]}
			unless match.nil?
				puts "Rule Matched: #{@description}"
				self.sub_vars(match.gsub(/\s*$/,'')) # chomp! was not working... had to do this
				@matched = true
			end
		end

		def sub_var(attribute, value)
			unless attribute.nil?
				attribute.gsub!(/#{Paperless::MATCH_VAR}/, value) 
				attribute.gsub!(/#{Paperless::DATE_VAR}/, @date_stamp.strftime(@date_default_format))

				# Custom date formats set at the rule level
				custom_date_regex = "#{Paperless::DATE_VAR.chop}=([a-zA-Z\%\-]+)>"
				if match = attribute.match(/#{custom_date_regex}/)
					attribute.gsub!(/#{custom_date_regex}/, @date_stamp.strftime(match[1])) 
				end
			end
			attribute
		end

		def sub_vars(value)
			# Need to do substituation for supported variables
			@destination = self.sub_var(@destination,value)
			@title = self.sub_var(@title,value)
			@date = self.sub_var(@date,value)
			@tags.collect! {|tag| tag = self.sub_var(tag,value) }			
		end

	end

end
