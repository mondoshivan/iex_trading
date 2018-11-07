
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
      else
        @results = Symbol.all
      end

      [:companyName, :exchange, :industry].each {|attribute|
        if @options[attribute]
          company_results = []
          search = "%" + @options[attribute].to_s.gsub("'", '') + "%"
          Company.all(attribute.like => search).each {|company|
            company_results << company.symbol
          }
          @results -= @results - company_results
        end
      }

      @results.uniq!
    end

    ##################
    def sort
      @results.sort! { |a, b|
        @options[:descending] ? b.name.downcase <=> a.name.downcase : a.name.downcase <=> b.name.downcase
      }
    end

    public

    ##################
    def start
      gather_results
      sort
      self
    end
  end
end
