require_relative "test_helper"

class DataPipesTest < Minitest::Test
  # https://pytorch.org/data/main/tutorial.html
  def test_works
    folder = "test/support"
    datapipe = TorchData::DataPipes::Iter::FileLister.new([folder]).filter { |filename| filename.end_with?(".csv") }
    datapipe = TorchData::DataPipes::Iter::FileOpener.new(datapipe, mode: "rt")
    datapipe = datapipe.parse_csv(delimiter: ",")
    train, valid = datapipe.random_split(total_length: 4, weights: {train: 0.5, valid: 0.5}, seed: 0)
    expected = [
      ["1", "one"],
      ["2", "two"],
      ["3", "three"],
      ["4", "four"]
    ]
    assert_equal expected, (train.to_a + valid.to_a).sort
    assert_equal 2, train.count
    assert_equal 2, valid.count
  end
end
