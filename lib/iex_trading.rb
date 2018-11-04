#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'net/http'
require 'json'
require 'data_mapper'
require 'dm-migrations'

require 'iex_trading/http'
require 'iex_trading/iex_api'
require 'iex_trading/log'
require 'iex_trading/option_parser'
require 'iex_trading/model/model'
require 'iex_trading/model/company'
require 'iex_trading/model/statistic'
require 'iex_trading/model/tag'
require 'iex_trading/model/financial'

DataMapper.setup(:default, "sqlite3://#{File.dirname(File.dirname(__FILE__))}/development.db")
DataMapper.finalize
DataMapper.auto_migrate!

module IEX_Trading

  ENTRY_POINT = File.basename(__FILE__)

  class Main

    ###################
    def initialize
      @parser = Parser.new(
          File.join(File.dirname(__FILE__), 'iex_trading', 'option_parser', 'config.yaml')
      )
      @parser.start
      @symbols = IEX_API.ref_data_symbols
    end

    ###################
    def company(symbol)
      hash = IEX_API.stock_company(
          symbol
      )
      tags = hash.delete('tags')
      company = Company.first_or_create(
          hash
      )

      tags.each { |tag|
        company.tags.new(name: tag)
      }

      company.statistics.new(
          IEX_API.stock_stats(
            symbol
        )
      )

      IEX_API.stock_financials(symbol).each { |financial|
        company.financials.new(financial)
      }

      company.save
      puts company
    end

    ###################
    def run
      begin
        case @parser.commands[0]
          when 'company'
            case @parser.commands[1]
              when nil
                company(@parser.options[:symbol])
                company(@parser.options[:symbol])
            end
          else
            raise 'illegal command'
        end
      rescue => e
        Log.warn("#{e.class} - #{e.message}")
        Log.print(e.backtrace.join("\n"))
      end
    end
  end
end

IEX_Trading::Main.new.run