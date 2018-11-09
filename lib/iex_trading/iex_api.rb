
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
      rs = HTTP.get("stock/#{symbol}/stats")
      rs.delete('companyName')
      rs.delete('symbol')
      rs
    end

    ###################
    def self.price(symbol)
      rs = HTTP.get("stock/#{symbol}/price")
      rs.to_f
    end

    ###################
    def self.stock_financials(symbol)
      HTTP.get("stock/#{symbol}/financials")['financials']
    end

  end
end
