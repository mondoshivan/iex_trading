

module IEX_Trading
  class Portfolio
    include DataMapper::Resource

    property :id, Serial
    property :name, String

    has n, :portfolioItems

  end
end