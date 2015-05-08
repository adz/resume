require_relative 'argument_parser'
require_relative 'messages'
require_relative 'gem_installer'
require_relative 'file_system'

module ResumeGenerator
  module CLI
    class Application
      include Messages

      attr_reader :locale
      attr_accessor :filename

      def self.start
        parser = ArgumentParser.new
        parser.parse!
        new(parser.locale).start
      end

      def initialize(locale)
        @locale = locale
        initialize_messages
      end

      def start
        install_gems
        generate_resume
        open_resume
      end

      private

      def install_gems
        installer = GemInstaller.new(self)
        return if installer.required_gems_available?
        request_gem_installation
        if permission_granted?
          thank_user_for_permission
          inform_start_of_gem_installation
          installer.install_gems
        else
          inform_of_failure_to_generate_resume
          exit
        end
      end

      def generate_resume
        inform_start_of_resume_generation
        Resume::Document.generate(self)
        inform_of_successful_resume_generation
      end

      def open_resume
        request_to_open_resume
        FileSystem.open_document(self) if permission_granted?
        print_thank_you_message
      end

      def permission_granted?
        gets.chomp.match(%r{\Ay(es)?\z}i)
      end
    end
  end
end
