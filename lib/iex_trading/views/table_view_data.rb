
module IEX_Trading
  class TableViewData

    attr_reader :data

    ##################
    def initialize
      @data = []
    end


    public

    ##################
    # ['th1', 'th2', ...]
    def headers(*array)
      array.each {|th|
        @data << [th]
      }
    end

    ##################
    def record(*attributes)
      attributes.each_with_index {|a, i|
        @data[i] << a
      }
    end
  end
end
