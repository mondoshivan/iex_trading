#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'net/http'
require 'json'

require 'iex_trading/factory'
require 'iex_trading/http'
require 'iex_trading/iex_api'
require 'iex_trading/log'
require 'iex_trading/option_parser'
require 'iex_trading/model/model'
require 'iex_trading/model/company'
require 'iex_trading/model/statistic'

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
      @factory = Factory.new
    end

    ###################
    def company(symbol)
      Log.print(
          @factory.company(
              IEX_API.stock_company(
                  symbol
              )
          )
      )
    end

    ###################
    def statistics(symbol)
      Log.print(
          @factory.statistic(
              IEX_API.stock_stats(
                  symbol
              )
          )
      )
    end

    ###################
    def run
      begin
        case @parser.commands[0]
          when 'company'
            case @parser.commands[1]
              when nil
                company(@parser.options[:symbol])
              when 'statistics'
                statistics(@parser.options[:symbol])
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