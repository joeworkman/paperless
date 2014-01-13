# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','paperless','version.rb'])

spec = Gem::Specification.new do |s| 
  s.name = 'paperless'
  s.version = Paperless::VERSION
  s.author = 'Joe Workman'
  s.email = 'joe@workmanmail.com'
  s.homepage = 'http://joeworkman.net/'
  s.description = 'A command-line utility for a Paperless that apply rules in order to auto-sort notes into supported services such as Finder, Evernote, DevonThink and PDFPen.'
  s.license = 'https://github.com/joeworkman/paperless/blob/master/LICENSE.txt'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command-line utility for a Paperless that apply rules in order to auto-sort notes into supported services such as Finder, Evernote, DevonThink and PDFPen'
# Add your other files here if you make them
  s.files = Dir['{bin,lib}/**/*']
  s.require_paths << 'lib'
  s.required_ruby_version = '>= 1.9.2'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','paperless.rdoc']
  s.rdoc_options << '--title' << 'paperless' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables = %(paperless)
  s.add_development_dependency('aruba', '~> 0.5', '>= 0.5.3')
  s.add_development_dependency('rake', '~> 10.1', '>= 10.1.0')
  s.add_development_dependency('rdoc', '~> 4.1', '>= 4.1.0')
  s.add_runtime_dependency('gli', '~> 2.5', '>= 2.5.4')
  s.add_runtime_dependency('markdown', '~> 1.1', '>= 1.1.1')
  s.add_runtime_dependency('pdf-reader', '~> 1.3', '>= 1.3.3')
  s.add_runtime_dependency('rb-appscript', '~> 0.6', '>= 0.6.1')
end
