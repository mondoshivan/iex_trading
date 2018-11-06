
module IEX_Trading
  class DataCollector

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


    public

    ###################
    def run
      Log.debug('Starting database update')
      IEX_API.ref_data_symbols.each_with_index {|symbol_hash, i|
        s = symbol(symbol_hash)
        s = company(s)
        s = statistics(s)
        s = financials(s)
        s.save

        i += 1
        Log.debug("#{i}. Symbol: #{s.symbol}")
      }
    end
  end
end