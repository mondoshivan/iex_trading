
module IEX_Trading
  class Company

    include DataMapper::Resource

    property :id,           Serial
    property :companyName,  String
    property :exchange,     String
    property :industry,     String
    property :website,      String
    property :description,  Text
    property :CEO,          String
    property :issueType,    String
    property :sector,       String

    belongs_to :symbolic

    has n, :tags
    has n, :statistics
    has n, :financials
  end
end