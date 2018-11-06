
module IEX_Trading
  class Tag
    include DataMapper::Resource

    belongs_to :company

    property :id, Serial
    property :name, String
  end
end