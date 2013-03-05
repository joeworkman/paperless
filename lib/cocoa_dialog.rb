# = CocoaDialog Wrapper Module

module CocoaDialog
	
	def bubble(title, text, options={:timeout => 3, :alpha => 0.9, :x => "right", :y => "top", :icon => nil})
		%x{
			#{CD} bubble --title #{title} \
			--text #{text} \
			--timeout #{options[:timeout]} \
			--x-placement #{options[:x]} \
			--y-placement #{options[:y]} \
			--icon #{options[:icon]}
		}
	end
	
	def msgbox(title, text, options={
		:button_1 => "OK",
		:button_2 => "Cancel",
		:button_3 => nil,
		:icon => nil,
		:float => true,
		:string_output => false,
		:width => nil,
		:height => nil,
		:yesno => false,
		:ok => false,
		:infotext => nil,
		:timeout => nil })
		# Returns either a string w/ either the text of the button pressed, or its number.
		if options[:yesno]
			%x{
				#{CD} yesno-msgbox \
				--title "#{title}" \
				--text "#{text}" \
				--no-newline \
				#{"--informative-text \"" + options[:infotext] + "\"" if options[:infotext]} \
				#{"--icon \"" + options[:icon] + "\"" if options[:icon]} \
				#{"--string-output" if options[:string_output]} \
				#{"--width " + options[:width] if options[:width]} \
				#{"--height " + options[:height] if options[:height]} \
				#{"--float" if options[:float]} \
				#{"--timeout " + options[:timeout] if options[:timeout]}
			}
		elsif options[:ok]
			%x{
				#{CD} ok-msgbox \
				--title "#{title}" \
				--text "#{text}" \
				--no-newline \
				#{"--informative-text \"" + options[:infotext] + "\"" if options[:infotext]} \
				#{"--icon \"" + options[:icon] + "\"" if options[:icon]} \
				#{"--string-output" if options[:string_output]} \
				#{"--width " + options[:width] if options[:width]} \
				#{"--height " + options[:height] if options[:height]} \
				#{"--float" if options[:float]} \
				#{"--timeout " + options[:timeout] if options[:timeout]}
			}
		elsif options[:ok] && options[:yesno]
			raise "Only one kind of menu can be selected."
		else
			%x{
				#{CD} msgbox \
				--title "#{title}" \
				--text "#{text}" \
				--no-newline \
				--button1 #{options[:button_1]} \
				--button2 #{options[:button_2]} \
				#{"--button3 \"" + options[:button_3] + "\"" if options[:button_3]} \
				#{"--informative-text \"" + options[:infotext] + "\"" if options[:infotext]} \
				#{"--icon \"" + options[:icon] + "\"" if options[:icon]} \
				#{"--string-output" if options[:string_output]} \
				#{"--width " + options[:width] if options[:width]} \
				#{"--height " + options[:height] if options[:height]} \
				#{"--float" if options[:float]} \
				#{"--timeout " + options[:timeout] if options[:timeout]}
			}
		end
	end
	
	def inputbox(title, text, options={
		:float => true,
		:string_output => true,
		:width => nil,
		:height => nil,
		:infotext => nil,
		:secure => false,
		:timeout => nil })
		# Returns an array: [<button number or label>, <text>]
		%x{
			#{CD} standard-inputbox \
			--title "#{title}" \
			--informative-text "#{text}" \
			--no-newline \
			#{"--no-show" if options[:secure]} \
			#{"--float" if options [:float]} \
			#{"--string-output" if options[:string_output]} \
			#{"--width " + options[:width] if options[:width]} \
			#{"--height " + options[:height] if options[:height]} \
			#{"--text \"" + options[:infotext] + "\"" if options[:infotext]} \
			#{"--timeout " + options[:timeout] if options[:timeout]}
		}.split("\n")
	end
	
	def fileselect(title, text, options={
		:directories => true,
		:only_directories => false,
		:multiple => true,
		:extensions => [],
		:start_directory => nil,
		:start_file => nil,
		:string_output => true,
		:width => nil,
		:height => nil,
		:float => true })
		%x{
			#{CD} fileselect \
			--title "#{title}" \
			--text "#{text}" \
			--no-newline \
			#{"--float" if options[:float]} \
			#{"--string-output" if options[:string_output]} \
			#{"--select-directories" if options[:directories]} \
			#{"--select-only-directories" if options[:only_directories]} \
			#{"--select-multuple" if options[:multiple]} \
			#{"--with-extensions " + options[:extensions].join("\ ") unless options[:extensions].empty?} \
			#{"--with-directory \"" + options[:start_directory] + "\"" if options[:start_directory]} \
			#{"--with-file \"" + options[:start_file] + "\"" if options[:start_file]} \
			#{"--width " + options[:width]} \
			#{"--height " + options[:height]}
		}
	end
	
	def filesave(title, text, options={
		:create_dirs => true,
		:extensions => [],
		:start_directory => nil,
		:start_file => nil,
		:string_output => true,
		:width => nil,
		:height => nil,
		:float => true })
		%x{
			#{CD} filesave \
			--title "#{title}" \
			--text "#{text}" \
			--no-newline \
			#{"--float" if options[:float]} \
			#{"--string-output" if options[:string_output]} \
			#{"--with-directory \"" + options[:start_directory] + "\"" if options[:start_directory]} \
			#{"--with-file \"" + options[:start_file] + "\"" if options[:start_file]} \
			#{"--with-extensions " + options[:extensions].join("\ ") unless options[:extensions].empty?} \
			#{"--width " + options[:width]} \
			#{"--height " + options[:height]}
		}
	end
	
	def textbox(title, text, options={
		:button_1 => "Ok",
		:button_2 => "Cancel",
		:button_3 => nil,
		:from_file => nil,
		:infotext => nil,
		:editable => true,
		:selected => false,
		:scroll_to => nil,
		:timeout => nil,
		:string_output => true,
		:width => nil, 
		:height => nil,
		:float => true })
		%x{
			#{CD} textbox \
			--title "#{title}" \
			--text "#{text}" \
			--no-newline \
			--button1 "#{options[:button_1]}" \
			--button2 "#{options[:button_2]}" \
			#{"--informative-text \"" + options[:infotext] + "\"" if options[:infotext]}
			#{"--button3 \"" + options[:button_3] + "\"" if options[:button_3]} \
			#{"--float" if options[:float]} \
			#{"--string-output" if options[:string_output]} \
			#{"--editable" if options[:editable]} \
			#{"--selected" if options[:selected]} \
			#{"--scroll-to \"" + options[:scroll_to] + "\"" if options[:scroll_to]} \
			#{"--text-from-file \"" + options[:from_file] + "\"" if options[:from_file]} \
			#{"--timeout " + options[:timeout] if options[:timeout]} \
			#{"--width " + options[:width] if options[:width]} \
			#{"--height " + options[:height] if options[:height]}
		}
	end
	
	def dropdown(title, text, options={
		:pulldown => false,
		:button_1 => "Ok",
		:button_2 => "Cancel",
		:button_3 => nil,
		:exit_on_change => false,
		:float => true,
		:timeout => nil,
		:string_output => true,
		:width => nil,
		:height => nil
	}, *items)
		%x{
			#{CD} dropdown \
			--title "#{title}" \
			--text "#{text}" \
			--items #{items.each {|item| print "\"" + item + "\" "}} \
			#{"--button1 \"" + options[:button_1] + "\"" if options[:button_1]} \
			#{"--button2 \"" + options[:button_2] + "\"" if options[:button_2]} \
			#{"--button3 \"" + options[:button_3] + "\"" if options[:button_3]} \
			#{"--exit-onchange" if options[:exit_on_change]} \
			#{"--float" if options[:float]} \
			#{"--timeout " + options[:timeout] if options[:timeout]} \
			#{"--width " + options[:width] if options[:width]} \
			#{"--height " + options[:height] if options[:height]} \
			#{"--pulldown" if options[:pulldown]} \
			#{"--string-output" if options[:string_output]}
		}
	end
	
end

class ProgressBar
	attr_reader :pid
	
	def initialize(title, text, options={ :indeterminate => false, :percent => 0 })
		system "rm -f /tmp/hpipe; mkfifo /tmp/hpipe"
		@pid = %x{
			#{CD} progressbar \
			--title "#{title}" \
			--text "#{text}" \
			#{"--indeterminate" if options[:indeterminate]}
			#{"--percent " + options[:percent] unless options[:indeterminate]} < /tmp/hpipe &
		}.slice(/\d+$/)
		system "exec 3<> /tmp/hpipe"
	end
	
	def update(percent)
		system "echo #{percent.to_s} >&3"
	end
	
	def finish
		system "exec 3>&-; wait; rm -f /tmp/hpipe"
	end
	
end