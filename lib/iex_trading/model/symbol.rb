

module IEX_Trading
  class Symbol
    include DataMapper::Resource

    property :symbol, String, key: true
    property :name, String
    property :date, String
    property :isEnabled, Boolean
    property :type, String
    property :iexId, Integer

    has 1, :company

  end
end