
module IEX_Trading
  class Company < Model

    include DataMapper::Resource

    property :companyName, String
    property :exchange,    String
    property :industry,    String
    property :website,     String
    property :description, String
    property :CEO,         String
    property :issueType,   String
    property :sector,      String

    belongs_to :symbol, key: true

    has n, :tags
    has n, :statistics
    has n, :financials
  end
end