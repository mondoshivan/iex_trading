
module IEX_Trading
  class Statistic

    include DataMapper::Resource

    belongs_to :company

    property :id, Serial
    property :marketcap, Float
    property :beta, Float
    property :week52high, 	Float
    property :week52low, 	Float
    property :week52change, 	Float
    property :shortInterest, 	Float
    property :shortDate, 	Date
    property :dividendRate, 	Float
    property :dividendYield, 	Float
    property :exDividendDate, 	DateTime
    property :latestEPS, 	Float
    property :latestEPSDate, 	Date
    property :sharesOutstanding, 	Float
    property :float, 	Float
    property :returnOnEquity, 	Float
    property :consensusEPS, 	Float
    property :numberOfEstimates, 	Integer
    property :EBITDA, Float
    property :revenue, Float
    property :grossProfit, Float
    property :cash, Float
    property :debt, Float
    property :ttmEPS, Float
    property :revenuePerShare, Float
    property :revenuePerEmployee, Float
    property :peRatioHigh, Float
    property :peRatioLow, Float
    property :EPSSurpriseDollar, Float
    property :EPSSurprisePercent, 	Float
    property :returnOnAssets, Float
    property :returnOnCapital, 	Float # check type
    property :profitMargin, Float
    property :priceToSales, Float
    property :priceToBook, Float
    property :day200MovingAvg, Float
    property :day50MovingAvg, Float
    property :institutionPercent, Float # check type
    property :insiderPercent, Float # check type
    property :shortRatio, Float
    property :year5ChangePercent, Float
    property :year2ChangePercent, Float
    property :year1ChangePercent, Float
    property :ytdChangePercent, Float
    property :month6ChangePercent, Float
    property :month3ChangePercent, Float
    property :month1ChangePercent, Float
    property :day5ChangePercent, Float
    property :day30ChangePercent, Float

  end
end
