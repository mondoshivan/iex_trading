
module IEX_Trading
  class DataCollector

    ###################
    def initialize
      IEX_API.ref_data_symbols.each {|symbol|
        s = IEX_Trading::Symbol.create(symbol)
        hash = IEX_API.stock_company(s.symbol)
        tags = hash.delete('tags')
        company = Company.create(hash)
        s.company = company
        s.company.save
        tags.each { |tag| s.company.tags << Tag.create(name: tag); s.save}
        s.company.statistics << Statistic.create(IEX_API.stock_stats(s.symbol))
        s.save
        IEX_API.stock_financials(s.symbol).each { |financial| s.company.financials << Financial.create(financial); s.save}
        s.save
        break
      }
      symbol = Symbol.first
      company = symbol.company
      puts 'asdf'
    end

    ###################
    def company(symbol)
      hash = IEX_API.stock_company(
          symbol
      )
      tags = hash.delete('tags')
      company = Company.first_or_create(
          hash
      )

      tags.each { |tag|
        company.tags.new(name: tag)
      }

      company.statistics.new(
          IEX_API.stock_stats(
              symbol
          )
      )

      IEX_API.stock_financials(symbol).each { |financial|
        company.financials.new(financial)
      }

    end

    public

    ###################
    def run

    end

  end
end