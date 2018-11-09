
module IEX_Trading
  class DataCollector

    ###################
    def initialize
      @shutdown = false
    end

    private

    ###################
    # creating the symbol
    def symbol(hash)
      s = IEX_Trading::Symbol.first(symbol: hash['symbol'])
      if s
        s.update(hash)
      else
        s = IEX_Trading::Symbol.new(hash)
        s.save
      end
      s
    end

    ###################
    # create the company
    def company(s)
      hash = IEX_API.stock_company(s.symbol)
      if s.company
        s.company.update(hash[:company])
      else
        s.company = IEX_Trading::Company.new(hash[:company])
      end
      s.save

      # creating the tags
      s.company.tags.destroy if s.company.tags.size > 0
      (hash[:tags] || []).each { |tag|
        s.company.tags << Tag.new(name: tag)
      }
      s.company.save
      s
    end

    ###################
    # creating the statistics
    def statistics(s)
      s.company.statistic = IEX_Trading::Statistic.new(
          IEX_API.stock_stats(s.symbol)
      )
      s.company.statistic.save
      s
    end

    ###################
    # creating the financials
    def financials(s)
      (IEX_API.stock_financials(s.symbol) || {}).each { |financial|
        next if s.company.financials.first(reportDate: financial['reportDate'])
        s.company.financials << IEX_Trading::Financial.new(financial)
      }
      s.save
      s
    end

    ###################
    def continue?(s)
      Log.debug(s)
      if @shutdown
        Log.debug('shutting down gracefully')
        return false
      end
      true
    end


    public

    ###################
    def shutdown
      @shutdown = true
    end

    ###################
    def run
      Log.debug('Starting database update')
      IEX_API.ref_data_symbols.each_with_index {|symbol_hash, i|
        begin
          s = symbol(symbol_hash)
          s = company(s)
          s = statistics(s)
          s = financials(s)
          s.save
          break unless continue?("#{i+1}. #{s.symbol}")
        rescue => e
          Log.error("#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
        end
      }
    end
  end
end