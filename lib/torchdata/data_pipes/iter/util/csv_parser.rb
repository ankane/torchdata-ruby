module TorchData
  module DataPipes
    module Iter
      module Util
        class CSVParser < IterDataPipe
          functional_datapipe :parse_csv

          def initialize(source_datapipe, delimiter: ",")
            @source_datapipe = source_datapipe
            @helper = PlainTextReaderHelper.new
            @fmtparams = {col_sep: delimiter}
          end

          def each(&block)
            @source_datapipe.each do |path, file|
              stream = @helper.skip_lines(file)
              stream = @helper.decode(stream)
              stream = CSV.parse(stream, **@fmtparams)
              stream = @helper.as_tuple(stream)
              @helper.return_path(stream, path: path).each(&block)
            end
          end
        end

        class PlainTextReaderHelper
          def skip_lines(file)
            file
          end

          def decode(stream)
            stream
          end

          def return_path(stream, path: nil)
            stream
          end

          def as_tuple(stream)
            stream
          end
        end
      end
    end
  end
end
