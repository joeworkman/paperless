# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','paperless','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'paperless'
  s.version = Paperless::VERSION
  s.author = 'Joe Workman'
  s.email = 'joe@workmanmail.com'
  s.homepage = 'http://joeworkman.net/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command-line utility for a Paperless that apply rules in order to auto-sort notes into supported services.'
# Add your other files here if you make them
  s.files = %w(
bin/CocoaDialog.app
bin/CocoaDialog.app/Contents
bin/CocoaDialog.app/Contents/Info.plist
bin/CocoaDialog.app/Contents/MacOS
bin/CocoaDialog.app/Contents/MacOS/CocoaDialog
bin/CocoaDialog.app/Contents/PkgInfo
bin/CocoaDialog.app/Contents/Resources
bin/CocoaDialog.app/Contents/Resources/atom.icns
bin/CocoaDialog.app/Contents/Resources/Changelog
bin/CocoaDialog.app/Contents/Resources/cocoadialog.icns
bin/CocoaDialog.app/Contents/Resources/computer.icns
bin/CocoaDialog.app/Contents/Resources/COPYING
bin/CocoaDialog.app/Contents/Resources/document.icns
bin/CocoaDialog.app/Contents/Resources/find.icns
bin/CocoaDialog.app/Contents/Resources/finder.icns
bin/CocoaDialog.app/Contents/Resources/firewire.icns
bin/CocoaDialog.app/Contents/Resources/folder.icns
bin/CocoaDialog.app/Contents/Resources/gear.icns
bin/CocoaDialog.app/Contents/Resources/globe.icns
bin/CocoaDialog.app/Contents/Resources/hazard.icns
bin/CocoaDialog.app/Contents/Resources/heart.icns
bin/CocoaDialog.app/Contents/Resources/hourglass.icns
bin/CocoaDialog.app/Contents/Resources/info.icns
bin/CocoaDialog.app/Contents/Resources/Info.plist
bin/CocoaDialog.app/Contents/Resources/InfoPlist.strings
bin/CocoaDialog.app/Contents/Resources/Inputbox.nib
bin/CocoaDialog.app/Contents/Resources/Inputbox.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/Inputbox.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/Inputbox.nib/keyedobjects.nib
bin/CocoaDialog.app/Contents/Resources/ipod.icns
bin/CocoaDialog.app/Contents/Resources/MainMenu.nib
bin/CocoaDialog.app/Contents/Resources/MainMenu.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/MainMenu.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/MainMenu.nib/info.nib.orig
bin/CocoaDialog.app/Contents/Resources/MainMenu.nib/objects.nib
bin/CocoaDialog.app/Contents/Resources/MainMenu.nib/objects.nib.orig
bin/CocoaDialog.app/Contents/Resources/Msgbox.nib
bin/CocoaDialog.app/Contents/Resources/Msgbox.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/Msgbox.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/Msgbox.nib/keyedobjects.nib
bin/CocoaDialog.app/Contents/Resources/person.icns
bin/CocoaDialog.app/Contents/Resources/PopUpButton.nib
bin/CocoaDialog.app/Contents/Resources/PopUpButton.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/PopUpButton.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/PopUpButton.nib/keyedobjects.nib
bin/CocoaDialog.app/Contents/Resources/Progressbar.nib
bin/CocoaDialog.app/Contents/Resources/Progressbar.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/Progressbar.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/Progressbar.nib/keyedobjects.nib
bin/CocoaDialog.app/Contents/Resources/SecureInputbox.nib
bin/CocoaDialog.app/Contents/Resources/SecureInputbox.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/SecureInputbox.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/SecureInputbox.nib/keyedobjects.nib
bin/CocoaDialog.app/Contents/Resources/sound.icns
bin/CocoaDialog.app/Contents/Resources/Textbox.nib
bin/CocoaDialog.app/Contents/Resources/Textbox.nib/classes.nib
bin/CocoaDialog.app/Contents/Resources/Textbox.nib/info.nib
bin/CocoaDialog.app/Contents/Resources/Textbox.nib/keyedobjects.nib
bin/CocoaDialog.app/Contents/Resources/x.icns
bin/paperless
bin/openmeta
lib/paperless/version.rb
lib/paperless/engine.rb
lib/paperless/rule.rb
lib/paperless/date_search.rb
lib/paperless/service/evernote.rb
lib/paperless/service/finder.rb
lib/paperless/service/devonthinkpro.rb
lib/paperless/ocr_engines/acrobat.rb
lib/paperless/ocr_engines/pdfpen.rb
lib/paperless/ocr_engines/pdfpenpro.rb
lib/paperless/ocr_engines/devonthinkpro.rb
lib/paperless.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','paperless.rdoc']
  s.rdoc_options << '--title' << 'paperless' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'paperless'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.4')
  s.add_runtime_dependency('rb-appscript')
  s.add_runtime_dependency('pdf-reader')
  s.add_runtime_dependency('markdown')
end
