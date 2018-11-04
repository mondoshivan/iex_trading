require 'optparse'
require 'yaml'

module IEX_Trading
  class Parser

    attr_reader :options
    attr_reader :commands

    ##################
    def initialize(config_file)
      @config = YAML::load_file(config_file)
      @options = {}
      @commands = []
    end

    private

    ##################
    def replace_commands(string)
      string.gsub(/\$\{COMMANDS\}/, @commands.join(' '))
    end

    ##################
    def replace_entry_point(string)
      string.gsub(/\$\{ENTRY_POINT\}/, ENTRY_POINT)
    end

    ##################
    def placeholders(string)
      string = replace_commands(string)
      replace_entry_point(string)
    end

    ##################
    def show_help(parser)
      Log.print(parser)
      exit 1
    end

    ##################
    def parse_options(hash)
      parser = OptionParser.new { |opts|
        opts.banner = placeholders(hash[:banner])
        opts.separator ''
        opts.separator placeholders(hash[:description])
        (hash[:options] || []).each {|option|
          opts.on(option[:short], option[:long], option[:description]) { |v|
            value = option[:key_value] ? option[:key_value] : v
            @options = @options.merge({option[:key_name].to_sym => value})
          }
        }
      }
      parser.order!
      command = ARGV.shift
      @commands << command if command
      show_help(parser) if @commands.empty?
      show_help(parser) if command.nil? && @options.empty?
      parse_options(hash[:commands][command]) if command
    end

    public

    ##################
    def start
      parse_options(@config[:parse])
    end

  end
end
