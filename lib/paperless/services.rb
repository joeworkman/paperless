require 'paperless/services/devonthinkpro.rb'
require 'paperless/services/evernote.rb'
require 'paperless/services/finder.rb'

module Paperless
  class Service
    CLASSES = [
      Paperless::Services::DevonThinkPro,
      Paperless::Services::Evernote,
      Paperless::Services::Finder
    ]

    def self.apply(identifier)
      CLASSES.detect { |klass| (identifier =~ /^#{klass::IDENTIFIER}$/i) }
    end
  end
end
