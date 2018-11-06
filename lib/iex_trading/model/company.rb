
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

    belongs_to :symbol

    has n, :tags
    has 1, :statistic
    has n, :financials
  end
end