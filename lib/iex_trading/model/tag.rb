
module IEX_Trading
  class Tag
    include DataMapper::Resource

    belongs_to :company

    property :name,       String, key: true
  end
end