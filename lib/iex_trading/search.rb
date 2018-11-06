
module IEX_Trading
  class Search

    attr_reader :results

    ##################
    def initialize(options)
      @options = options
      @results = []
    end

    private

    ##################
    def gather_results
      if @options[:symbol]
        search = "%" + @options[:symbol].to_s.gsub("'", '') + "%"
        @results = Symbol.all(:symbol.like => search)
      end

      [:companyName, :exchange, :industry].each {|attribute|
        if @options[attribute]
          search = "%" + @options[attribute].to_s.gsub("'", '') + "%"
          Company.all(attribute.like => search).each {|company|
            @results << company.symbol
          }
        end
      }

      @results.uniq!
    end

    public

    ##################
    def pretty_results
      @results.each_with_index.map do |result, i|
        company = result.company
        "#{i}.\t#{result.symbol}\t#{company.exchange}\t#{company.industry}\t\t#{result.name}"
      end
    end

    ##################
    def start
      gather_results
      self
    end
  end
end
