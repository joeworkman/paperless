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
bin/paperless
lib/paperless/version.rb
lib/paperless/engine.rb
lib/paperless/rule.rb
lib/paperless/service/evernote.rb
lib/paperless/service/finder.rb
lib/paperless/ocr_engines/pdfpen.rb
lib/paperless/ocr_engines/pdfpenpro.rb
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
end
