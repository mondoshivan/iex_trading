

module IEX_Trading
  class Financial
    include DataMapper::Resource

    belongs_to :company

    property :id, Serial
    property :reportDate, String
    property :grossProfit, Float
    property :costOfRevenue, Float
    property :operatingRevenue, Float
    property :totalRevenue, Float
    property :operatingIncome, Float
    property :netIncome, Float
    property :researchAndDevelopment, Float
    property :operatingExpense, Float
    property :currentAssets, Float
    property :totalAssets, Float
    property :totalLiabilities, Float
    property :currentCash, Float
    property :currentDebt, Float
    property :totalCash, Float
    property :totalDebt, Float
    property :shareholderEquity, Float
    property :cashChange, Float
    property :cashFlow, Float
    property :operatingGainsLosses, Float
  end
end