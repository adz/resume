require 'tmpdir'
require 'pathname'

module Resume
  module CLI
    class FileSystem
      def self.open_document(filename)
        case RUBY_PLATFORM
        when %r(darwin)
          system('open', filename)
        when %r(linux)
          system('xdg-open', filename)
        when %r(windows)
          system('cmd', '/c', "\"start #{filename}\"")
        else
          Output.warning(:dont_know_how_to_open_resume)
        end
      end

      def self.tmpfile_path(filename)
        # Ensure that the ?dl=1 parameter is removed
        Pathname.new(Dir.tmpdir).join(filename.sub(/\?.+\z/, ''))
      end
    end
  end
end
