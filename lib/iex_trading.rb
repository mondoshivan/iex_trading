#!/usr/bin/env ruby

lib = File.expand_path('../../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'net/http'
require 'json'
require 'data_mapper'
require 'dm-migrations'

project_root = File.expand_path('../../', __FILE__)
DataMapper.setup(:default, "sqlite3://#{project_root}/development.db")

require 'iex_trading/http'
require 'iex_trading/iex_api'
require 'iex_trading/log'
require 'iex_trading/option_parser'
require 'iex_trading/data_collector'
require 'iex_trading/model/model'
require 'iex_trading/model/company'
require 'iex_trading/model/statistic'
require 'iex_trading/model/tag'
require 'iex_trading/model/financial'
require 'iex_trading/model/symbol'

DataMapper.finalize
# DataMapper.auto_migrate!

module IEX_Trading

  ENTRY_POINT = File.basename(__FILE__)

  class Main

    ###################
    def initialize
      @argv = ARGV.clone
      @parser = Parser.new(
          File.join(File.dirname(__FILE__), 'iex_trading', 'option_parser', 'config.yaml')
      )
      @parser.start
    end

    ###################
    def company(symbol)
      hash = IEX_Trading::IEX_API.stock_company(symbol)
      Log.print JSON.pretty_generate(hash)
    end

    ###################
    def update
      if @parser.options[:detach]
        args = @argv.delete_if{|e| e == '-d' || e == '--detach'}.join(' ')
        command = "'#{__FILE__}' #{args} > /dev/null 2>&1"
        pid = spawn(command)
        Log.print(pid)
      else
        DataCollector.new.run
      end
    end

    ###################
    def statistic(symbol)
      hash = IEX_Trading::IEX_API.stock_stats(symbol)
      Log.print JSON.pretty_generate(hash)
    end

    ###################
    def run
      begin
        case @parser.commands[0]
          when 'company'
            case @parser.commands[1]
              when nil
                company(@parser.options[:symbol])
              when 'statistic'
                statistic(@parser.options[:symbol])
            end
          when 'update'
            update
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