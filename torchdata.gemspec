require_relative "lib/torchdata/version"

Gem::Specification.new do |spec|
  spec.name          = "torchdata"
  spec.version       = TorchData::VERSION
  spec.summary       = "Composable data loading for Ruby"
  spec.homepage      = "https://github.com/ankane/torchdata-ruby"
  spec.license       = "BSD-3-Clause"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.7"

  spec.add_dependency "torch-rb", ">= 0.12.2"
end
