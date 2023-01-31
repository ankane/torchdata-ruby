module TorchData
  module DataPipes
    module Iter
      module Util
        class RandomSplitter < IterDataPipe
          functional_datapipe :random_split

          def self.new(source_datapipe, weights:, seed:, total_length: nil, target: nil)
            if total_length.nil?
              begin
                total_length = source_datapipe.length
              rescue NoMethodError
                raise TypeError, "RandomSplitter needs `total_length`, but it is unable to infer it from the `source_datapipe`: #{source_datapipe}."
              end
            end

            container = InternalRandomSplitterIterDataPipe.new(source_datapipe, total_length, weights, seed)

            if target.nil?
              weights.map { |k, _| SplitterIterator.new(container, k) }
            else
              raise "todo"
            end
          end
        end

        class InternalRandomSplitterIterDataPipe < IterDataPipe
          attr_reader :source_datapipe

          def initialize(source_datapipe, total_length, weights, seed)
            @source_datapipe = source_datapipe
            @total_length = total_length
            @remaining_length = @total_length
            @seed = seed
            @keys = weights.keys
            @key_to_index = @keys.map.with_index.to_h
            @norm_weights = self.class.normalize_weights(@keys.map { |k| weights[k] }, total_length)
            @weights = @norm_weights.dup
            @rng = Random.new(@seed)
            @lengths = []
          end

          def draw
            selected_key = choices(@rng, @keys, @weights)
            index = @key_to_index[selected_key]
            @weights[index] -= 1
            @remaining_length -= 1
            if @weights[index] < 0
              @weights[index] = 0
              @weights = self.class.normalize_weights(@weights, @remaining_length)
            end
            selected_key
          end

          def self.normalize_weights(weights, total_length)
            total_weight = weights.sum
            weights.map { |w| w.to_f * total_length / total_weight }
          end

          def reset
            @rng = Random.new(@seed)
            @weights = @norm_weights.dup
            @remaining_length = @total_length
          end

          def override_seed(seed)
            @seed = seed
            self
          end

          def get_length(target)
            raise "todo"
          end

          private

          def choices(rng, keys, weights)
            total = weights.sum
            x = rng.rand * total
            weights.each_with_index do |w, i|
              return keys[i] if x < w
              x -= w
            end
            keys[-1]
          end
        end

        class SplitterIterator < IterDataPipe
          def initialize(main_datapipe, target)
            @main_datapipe = main_datapipe
            @target = target
          end

          def each
            @main_datapipe.reset
            @main_datapipe.source_datapipe.each do |sample|
              if @main_datapipe.draw == @target
                yield sample
              end
            end
          end

          def override_seed(seed)
            @main_datapipe.override_seed(seed)
          end

          def length
            @main_datapipe.get_length(@target)
          end
        end
      end
    end
  end
end
