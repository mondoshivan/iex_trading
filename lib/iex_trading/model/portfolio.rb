

module IEX_Trading
  class Portfolio
    include DataMapper::Resource

    property :id, Serial
    property :name, String

  end
end