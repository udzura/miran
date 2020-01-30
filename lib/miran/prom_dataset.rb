module Miran
  class PromDataset
    def initialize(data)
      @type = data.dig("data", "resultType")
      results = data.dig("data", "result").
                  map {|elem| PromData.new(elem) }
      @elements = results.with_object({}) do |elem, ha|
        ha[elem.name] = elem
      end
    end
    attr_reader :type, :elements
    def [](name)
      self.elements[name]
    end
  end

  class PromData
    def initialize(elem)
      @name = elem.dig("metric", "name")
      @metadata = elem["metric"]
      @values = Hash[elem["values"]]
    end
    attr_reader :name, :metadata, :values

    def data_x
      values.keys
    end

    def data_y
      values.values
    end
  end
end
