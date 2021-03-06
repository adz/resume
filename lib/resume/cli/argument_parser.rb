require 'optparse'
require_relative 'exceptions'

module Resume
  module CLI
    class ArgumentParser
      def self.parse
        help = parser.help
        parser.parse!(ARGV)
      rescue OptionParser::InvalidOption
        raise InvalidOptionError, help
      rescue OptionParser::MissingArgument
        raise MissingArgumentError, help
      end

      def self.parser
        OptionParser.new do |opts|
          blank_line = opts.separator ''
          opts.banner = 'Usage: ./bin/resume [options]'
          blank_line
          opts.separator 'Specific options:'
          locale_option(opts)
          blank_line
          opts.separator 'Common options:'
          help_option(opts)
          version_option(opts)
        end
      end
      private_class_method :parser

      def self.locale_option(opts)
        opts.on('-l', '--locale LOCALE',
          "Select the locale of the resume "\
          "(#{I18n.available_locales.join(', ')})") do |locale|
          begin
            I18n.locale = locale.to_sym
          rescue I18n::InvalidLocale
            raise LocaleNotSupportedError, locale
          end
        end
      end
      private_class_method :locale_option

      def self.help_option(opts)
        opts.on_tail('-h', '--help', 'Show this message') do
          Output.raw(opts)
          throw :halt
        end
      end
      private_class_method :help_option

      def self.version_option(opts)
        opts.on_tail('-v', '--version', 'Show version') do
          Output.raw(Resume::VERSION)
          throw :halt
        end
      end
      private_class_method :version_option
    end
  end
end
