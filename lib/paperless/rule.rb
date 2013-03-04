module Paperless

	class Rule

		def initialize(options)
			# @todo: Add logic to validate rule has proper settings

			@scope 		 = options['scope'].split
			@condition = options['condition']
			@notebook  = options['notebook']
			@service  = options['service']
			@title 		 = options['title']
			@date 		 = options['date']
			@tags			 = options['tags'].nil? ? Array.new : options['tags'].split
			@date_stamp = DateTime.now
			@date_default = '%Y-%m-%d'
			@matched   = false
		end

		attr_reader :matched, :tags, :notebook, :condition, :title, :date, :service

		def set_date(date,format)
			@date_stamp = date
			@date_default = format
		end

		def match(file,text)
			return @matched if @matched

			if @condition == Paperless::DATE_VAR
				puts "Rule Matched: (#{@scope.to_s}: #{@condition})"
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
				puts "Rule Matched: #{match} (#{@scope.join('/')}: #{@condition})"
				self.sub_vars(match.gsub(/\s*$/,'')) # chomp! was not working... had to do this
				@matched = true
			end
		end

		def sub_var(attibute, value)
			unless attibute.nil?
				attibute.gsub!(/<match>/, value) 
				attibute.gsub!(/<date>/, @date_stamp.strftime(@date_default))

				# Custom date formats set at the rule level
				custom_date_regex = "<date=([a-z\%\-]+)>"
				if match = attibute.match(/#{custom_date_regex}/)
					attibute.gsub!(/#{custom_date_regex}/, @date_stamp.strftime(match[1])) 
				end
			end
		end

		def sub_vars(value)
			# Need to do substituation for supported variables
			@notebook = self.sub_var(@notebook,value)
			@title = self.sub_var(@title,value)
			@date = self.sub_var(@date,value)
			@tags.collect! {|tag| self.sub_var(tag,value) }
		end

	end

end
