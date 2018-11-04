
module IEX_Trading
  class Log

    ###################
    def self.print(s)
      puts s
    end

    ###################
    def self.debug(s)
      puts s
    end

    ###################
    def self.info(s)
      puts s
    end

    ###################
    def self.warn(s)
      puts s
    end

    ###################
    def self.error(s)
      puts s
    end

    ###################
    def self.fatal(s)
      puts s
      exit 1
    end

  end
end
