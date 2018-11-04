
module IEX_Trading
  class Statistic < Model

    include DataMapper::Resource

    belongs_to :company

    property :symbol, 	String, key: true
    property :companyName, String
    property :marketcap, Float
    property :beta, Decimal
    property :week52high, 	Decimal
    property :week52low, 	Decimal
    property :week52change, 	Decimal
    property :shortInterest, 	Float
    property :shortDate, 	String
    property :dividendRate, 	Decimal
    property :dividendYield, 	Decimal
    property :exDividendDate, 	String
    property :latestEPS, 	Decimal
    property :latestEPSDate, 	String
    property :sharesOutstanding, 	Float
    property :float, 	Float
    property :returnOnEquity, 	Decimal
    property :consensusEPS, 	Decimal
    property :numberOfEstimates, 	Integer
    property :EBITDA, Float
    property :revenue, Float
    property :grossProfit, Float
    property :cash, Float
    property :debt, Float
    property :ttmEPS, Decimal
    property :revenuePerShare, Decimal
    property :revenuePerEmployee, Decimal
    property :peRatioHigh, Decimal
    property :peRatioLow, Decimal
    property :EPSSurpriseDollar, Decimal
    property :EPSSurprisePercent, 	Decimal
    property :returnOnAssets, Decimal
    property :returnOnCapital, 	Decimal # check type
    property :profitMargin, Decimal
    property :priceToSales, Decimal
    property :priceToBook, Decimal
    property :day200MovingAvg, Decimal
    property :day50MovingAvg, Decimal
    property :institutionPercent, Decimal # check type
    property :insiderPercent, Decimal # check type
    property :shortRatio, Decimal
    property :year5ChangePercent, Decimal
    property :year2ChangePercent, Decimal
    property :year1ChangePercent, Decimal
    property :ytdChangePercent, Decimal
    property :month6ChangePercent, Decimal
    property :month3ChangePercent, Decimal
    property :month1ChangePercent, Decimal
    property :day5ChangePercent, Decimal
    property :day30ChangePercent, Decimal

  end
end
