# TorchData Ruby

Composable data loading for Ruby

[![Build Status](https://github.com/ankane/torchdata-ruby/actions/workflows/build.yml/badge.svg)](https://github.com/ankane/torchdata-ruby/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "torchdata"
```

## Getting Started

This library follows the [Python API](https://pytorch.org/data/). Many methods and options are missing at the moment. PRs welcome!

```ruby
folder = "path/to/csv/folder"
datapipe = TorchData::DataPipes::Iter::FileLister.new([folder]).filter { |filename| filename.end_with?(".csv") }
datapipe = TorchData::DataPipes::Iter::FileOpener.new(datapipe, mode: "rt")
datapipe = datapipe.parse_csv(delimiter: ",")
train, valid = datapipe.random_split(total_length: 10000, weights: {train: 0.5, valid: 0.5}, seed: 0)

train.each do |x|
  # code
end

valid.each do |y|
  # code
end
```

## History

View the [changelog](CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/torchdata-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/torchdata-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/torchdata-ruby.git
cd torchdata-ruby
bundle install
bundle exec rake test
```
