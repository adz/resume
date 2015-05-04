require_relative 'header'
require_relative 'company_logo'

module ResumeGenerator
  module Resume
    module Entry
      class Content
        include Decoder, TransparentLink

        attr_reader :pdf, :entry

        def self.generate(pdf, entry)
          new(pdf, entry).generate
        end

        def generate
          pdf.move_down entry[:top_padding]
          Header.generate(pdf, entry)
          CompanyLogo.generate(pdf, entry)
          details if entry.has_key?(:summary)
        end

        private

        def initialize(pdf, entry)
          @pdf = pdf
          @entry = entry
        end

        def details
          pdf.move_down entry[:summary][:top_padding]
          summary
          profile
        end

        def summary
          pdf.text(d(entry[:summary][:text]), inline_format: true)
        end

        def profile
          items = entry[:profile]
          return unless items
          table_data = items.reduce([]) do |data, item|
            data << ['-', d(item)]
          end
          pdf.table(
            table_data,
            cell_style: {
              borders: entry[:cell_style][:borders],
              height: entry[:cell_style][:height]
            }
          )
        end
      end
    end
  end
end

