#!/usr/bin/env ruby

lib = File.expand_path('../../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'net/http'
require 'json'
require 'data_mapper'
require 'dm-migrations'

require 'iex_trading/http'
require 'iex_trading/iex_api'
require 'iex_trading/log'
require 'iex_trading/option_parser'
require 'iex_trading/data_collector'
require 'iex_trading/search'
require 'iex_trading/model/model'
require 'iex_trading/model/company'
require 'iex_trading/model/statistic'
require 'iex_trading/model/tag'
require 'iex_trading/model/financial'
require 'iex_trading/model/symbol'
require 'iex_trading/model/portfolio'
require 'iex_trading/model/portfolio_item'
require 'iex_trading/views/table_view'
require 'iex_trading/views/table_view_data'

module IEX_Trading

  ENTRY_POINT = File.basename(__FILE__)

  class Main

    ###################
    def initialize
      @shutdown = false
      @argv = ARGV.clone
      @parser = Parser.new(
          File.join(File.dirname(__FILE__), 'iex_trading', 'option_parser', 'config.yaml')
      )
      @parser.start
      logging
      database
      @data_collector = DataCollector.new
    end

    private

    ###################
    def logging
      file_name = File.basename(__FILE__, '.rb')
      log_file = "/usr/local/var/#{file_name}/#{file_name}.log"
      Log.file = @parser.options[:log_file] ? @parser.options[:log_file] : log_file
      Log.level = @parser.options[:log_level] || 'warn'
    end

    ###################
    def database
      project_root = File.expand_path('../../', __FILE__)
      DataMapper.setup(:default, "sqlite3://#{project_root}/development.db")
      DataMapper.finalize
      mode = ENV['IEX_TRADING_MODE']
      if mode && mode.upcase == 'DEVELOPMENT'
        Log.info('Running in development mode')
        DataMapper.auto_migrate!
      else
        Log.info('Running in production mode')
        DataMapper.auto_upgrade!
      end
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
        Log.print("\n")
      else
        @data_collector.run
      end
    end

    ###################
    def search(options)
      s = Search.new(options)
      s = s.start

      t_data = TableViewData.new
      t_data.headers('Symbol', 'Exchange', 'Industry', 'Company Name')
      s.results.each { |result|
        company = result.company
        t_data.record(
            result.symbol,
            company.exchange,
            company.industry,
            result.name
        )
      }

      t_view = TableView.new(t_data)
      t_view.print
    end

    ###################
    def statistic(symbol)
      hash = IEX_Trading::IEX_API.stock_stats(symbol)
      Log.print JSON.pretty_generate(hash)
    end

    ###################
    def portfolio_list
      portfolios = Portfolio.all

      t_data = TableViewData.new
      t_data.headers('Name')
      portfolios.each { |result|
        t_data.record(
            result.name
        )
      }

      t_view = TableView.new(t_data)
      t_view.print
    end

    ###################
    def portfolio_new
      p = Portfolio.first(name: @parser.options[:name])
      raise "portfolio exists: #{@parser.options[:name]}" if p
      p = Portfolio.new(name: @parser.options[:name])
      p.save
    end

    ###################
    def portfolio_item_new
      p = Portfolio.first(name: @parser.options[:portfolio])
      raise "portfolio does not exist: #{@parser.options[:portfolio]}" unless p

      s = Symbol.first(symbol: @parser.options[:symbol])
      raise "symbol does not exist: #{@parser.options[:symbol]}" unless s

      p.portfolioItems << PortfolioItem.new(
          symbol: s,
          amount: @parser.options[:amount],
          buyDateTime: Time.now
      )
      p.save
    end

    ###################
    def portfolio_item_list
      p = Portfolio.first(name: @parser.options[:portfolio])
      raise "portfolio does not exist: #{@parser.options[:portfolio]}" unless p

      t_data = TableViewData.new
      t_data.headers('Symbol', 'Name', 'Bought', 'Price', 'Amount', 'Value')
      p.portfolioItems.each { |result|
        symbol = result.symbol.symbol
        price = IEX_Trading::IEX_API.price(symbol)
        t_data.record(
            symbol,
            result.symbol.name,
            result.buyDateTime.strftime('%Y-%^b-%d|%T'),
            price,
            result.amount,
            (result.amount * price).round(2)
        )
      }

      t_view = TableView.new(t_data)
      t_view.print
    end

    public

    ###################
    def shutdown_gracefully
      @data_collector.shutdown
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
              else
                raise 'illegal command'
            end
          when 'search'
            search(@parser.options)
          when 'update'
            update
          when 'portfolio'
            case @parser.commands[1]
              when 'list'
                portfolio_list
              when 'new'
                portfolio_new
              when 'item'
                case @parser.commands[2]
                  when 'new'
                    portfolio_item_new
                  when 'list'
                    portfolio_item_list
                end
              else
                raise 'illegal command'
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

iex = IEX_Trading::Main.new

# catch the signal and
# perform a controlled shutdown
Signal.trap("INT") {
  iex.shutdown_gracefully
}

iex.run