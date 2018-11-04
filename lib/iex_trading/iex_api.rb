
class IEX_API

  ###################
  def self.ref_data_symbols
    HTTP.get('ref-data/symbols')
  end

  ###################
  def self.stock_company(symbol)
    HTTP.get("stock/#{symbol}/company")
  end

  ###################
  def self.stock_stats(symbol)
    HTTP.get("stock/#{symbol}/stats")
  end

end