
module IEX_Trading
  class PortfolioItem
    include DataMapper::Resource

    property :id, Serial
    property :amount, Float

    has 1, :symbol
    belongs_to :portfolio
  end
end