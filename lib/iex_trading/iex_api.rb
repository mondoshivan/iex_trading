
module IEX_Trading
  class IEX_API

    ###################
    def self.ref_data_symbols
      HTTP.get('ref-data/symbols')
    end

    ###################
    def self.stock_company(symbol)
      company = HTTP.get("stock/#{symbol}/company")
      company.delete('symbol')
      tags = company.delete('tags')
      {company: company, tags: tags}
    end

    ###################
    def self.stock_stats(symbol)
      stats = HTTP.get("stock/#{symbol}/stats")
      stats.delete('companyName')
      stats.delete('symbol')
      stats
    end

    ###################
    def self.stock_financials(symbol)
      HTTP.get("stock/#{symbol}/financials")['financials']
    end

  end
end
