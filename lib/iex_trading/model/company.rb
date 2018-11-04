
module IEX_Trading
  class Company < Model

    include DataMapper::Resource

    property :symbol,      String, :key => true
    property :companyName, String
    property :exchange,    String
    property :industry,    String
    property :website,     String
    property :description, String
    property :CEO,         String
    property :issueType,   String
    property :sector,      String

    has n, :tags
    has n, :statistics
    has n, :financials
  end
end