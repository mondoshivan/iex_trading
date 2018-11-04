
module IEX_Trading
  class Factory

    ###################
    def initialize
      @companies = []
    end

    ###################
    def company(hash)
      return find_company(hash['symbol']) if company_exists?(hash)
      c = Company.new
      c.symbol = hash['symbol']
      c.company_name = hash['companyName']
      c.exchange = hash['exchange']
      c.industry = hash['industry']
      c.website = hash['website']
      c.description = hash['description']
      c.ceo = hash['CEO']
      c.issue_type = hash['issueType']
      c.sector = hash['sector']
      c.tags = hash['tags']
      c
    end

    ###################
    def statistic(hash)
      s = Statistic.new
      s.symbol = hash['symbol']
      s.market_cap = hash['market_cap']
      s.beta = hash['beta']
      s
    end

    ###################
    def find_company(symbol)
      @companies.each {|stored| return stored if stored.symbol == symbol}
      nil
    end

    ###################
    def company_exists?(symbol)
      @companies.each {|stored| return true if stored.symbol == symbol}
      false
    end
  end
end
