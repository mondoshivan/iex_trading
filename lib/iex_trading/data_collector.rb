
module IEX_Trading
  class DataCollector

    public

    ###################
    def run
      IEX_API.ref_data_symbols.each {|symbol_hash|
        s = IEX_Trading::Symbolic.new(symbol_hash)
        company_hash = IEX_API.stock_company(s.symbol)
        tags = company_hash.delete('tags')
        s.company = IEX_Trading::Company.new(company_hash)
        tags.each { |tag| s.company.tags << Tag.new(name: tag)}
        stats_hash = IEX_API.stock_stats(s.symbol)
        s.company.statistics << Statistic.new(stats_hash)
        IEX_API.stock_financials(s.symbol).each { |financial|
          s.company.financials << Financial.new(financial)
        }
        s.save
        break
      }

      all = IEX_Trading::Symbolic.all
      first = all.first
      company = first.company
      return
    end
  end
end