# dependencies
require "torch"

# stdlib
require "csv"

# modules
require_relative "torchdata/version"

module TorchData
  class Error < StandardError; end

  module DataPipes
    module Iter
      IterDataPipe = Torch::Utils::Data::DataPipes::IterDataPipe
      FileLister = Torch::Utils::Data::DataPipes::Iter::FileLister
      FileOpener = Torch::Utils::Data::DataPipes::Iter::FileOpener
    end
  end
end

require_relative "torchdata/data_pipes/iter/util/csv_parser"
require_relative "torchdata/data_pipes/iter/util/random_splitter"
