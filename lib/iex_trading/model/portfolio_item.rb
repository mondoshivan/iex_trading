
module IEX_Trading
  class PortfolioItem
    include DataMapper::Resource

    property :id, Serial
    property :amount, Float
    property :buyDateTime, DateTime, required: true

    belongs_to :symbol
    belongs_to :portfolio
  end
end