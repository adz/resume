require_relative 'exceptions'
require_relative 'exception_suppressor'
require_relative 'file_fetcher'

module Resume
  module CLI
    class Settings
      extend ExceptionSuppressor

      def self.configure
        # Ignore requiring gems that are used just for development
        suppress(LoadError) do
          require 'pry-byebug'
        end
        configure_i18n
      end

      def self.configure_i18n
        require 'i18n'
        I18n.available_locales = [:en, :it, :ja]
        I18n.available_locales.each do |locale|
          I18n.load_path += [
            FileFetcher.fetch("lib/resume/locales/#{locale}.yml")
          ]
        end
      rescue LoadError
        raise DependencyPrerequisiteError
      end
      private_class_method :configure_i18n
    end
  end
end
