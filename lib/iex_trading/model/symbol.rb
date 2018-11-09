

module IEX_Trading
  class Symbol
    include DataMapper::Resource

    property :id, Serial
    property :symbol, String
    property :name, String
    property :date, Date
    property :isEnabled, Boolean
    property :type, String
    property :iexId, Integer

    has 1, :company

  end
end