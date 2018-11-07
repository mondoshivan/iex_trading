require 'logger'

module IEX_Trading

  module LogColor
    if RUBY_PLATFORM =~ /mswin|mingw|cygwin|windows/
      RED = '[41m'
      YELLOW = '[43m'
      NO_COLOR = '[0m'
    else
      RED = "\033[0;31m"
      YELLOW = "\033[1;33m"
      NO_COLOR = "\033[0m"
    end
  end

  class Log

    @no_color_logging = false
    @log_debug_mode = 1
    @log_level = Logger::WARN
    @log_stdout = [Logger.new(STDOUT)]
    @log_stderr = [Logger.new(STDERR)]


    ########################
    def self.objects(**options)
      return @log_stdout if options[:stdout]
      return @log_stderr if options[:stderr]
      (@log_stdout + @log_stderr)
    end

    ########################
    def self.severity_color(severity)
      case severity
        when 'WARN'
          color = LogColor::YELLOW
        when 'ERROR', 'FATAL'
          color = LogColor::RED
        else
          color = LogColor::NO_COLOR
      end
      color
    end

    ########################
    # sets the logging format
    def self.format=(proc_object)
      Log.objects.each do |logger|
        logger.formatter = Proc.new {|severity, datetime, progname, msg|
          color, no_color = ''
          unless Log.no_color_logging
            no_color = LogColor::NO_COLOR
            color = Log.severity_color(severity)
          end
          string = proc_object.call(severity, datetime, progname, msg)
          "#{color}#{string}#{no_color}"
        }
      end
    end

    # default setting of the log format
    Log.format = Proc.new { |severity, datetime, progname, msg|
      datetime = datetime.strftime("%Y-%m-%dT%H:%M:%S,%6N ##{Process.pid}")
      severity_id = severity[0]
      # add a space for info and warn to match the str length of debug, error and fatal
      severity = ' ' + severity if severity.length < 5
      "#{severity_id}, [#{datetime}] #{severity} -- #{progname}: #{msg}\n"
    }

    ########################
    def self.no_color_logging=(bool)
      @no_color_logging = true if bool.to_s == "true"
    end

    ########################
    def self.no_color_logging
      @no_color_logging
    end

    ########################
    # stores the log level:
    # - Logger::DEBUG, Logger::INFO, Logger::WARN, Logger::ERROR
    #
    def self.level=(l)
      return unless l.kind_of?(String)
      @log_level = Log.convert_level(l)
      Log.set_level
    end

    ########################
    # sets the log level
    def self.set_level
      Log.objects.each {|logger| logger.level = @log_level}
    end

    ########################
    def self.debug_mode=(i)
      return unless i.kind_of?(String)
      @log_debug_mode = Integer(i)
    end

    ########################
    def self.debug_mode
      @log_debug_mode
    end

    ########################
    def self.debug(s)
      @log_stdout.each {|logger| logger.debug(short_caller(caller[2])) {s}} if Log.debug_mode > 0
    end

    ########################
    def self.debug2(s)
      @log_stdout.each {|logger| logger.debug(short_caller(caller[2])) {s}} if Log.debug_mode > 1
    end

    ########################
    def self.debug3(s)
      @log_stdout.each {|logger| logger.debug(short_caller(caller[2])) {s}} if Log.debug_mode > 2
    end

    ########################
    def self.info(s)
      @log_stdout.each {|logger| logger.info(short_caller(caller[2])) {s}}
    end

    ########################
    def self.warn(s)
      @log_stdout.each {|logger| logger.warn(short_caller(caller[2])) {s}}
    end

    ########################
    def self.error(s)
      @log_stdout.each {|logger| logger.error(short_caller(caller[2])) {s}}
    end

    ########################
    def self.fatal(s)
      @log_stdout.each {|logger| logger.fatal(short_caller(caller[2])) {s}}
      exit 1
    end

    ########################
    def self.exception(s)
      @log_stdout.each {|logger| logger.error(short_caller(caller[2])) {s}}
      raise StandardError, s
    end

    ########################
    def self.print(s)
      @log_stdout.each {|logger| logger << "#{s}"}
    end

    ########################
    # sets the log file
    #
    def self.file=(f)
      return if f.nil?
      FileUtils.mkdir_p(File.dirname(f)) && FileUtils.touch(f) unless File.exists?(f)
      @log_stdout << Logger.new(f)
      @log_stderr << Logger.new(f)
      Log.set_level
      @log_file = f
    end

    ########################
    def self.file
      @log_file
    end

    ########################
    # convert the level for the logger object
    #
    # * *Args*    :
    #   - +level+ -> level (string, int)
    # * *Returns* :
    #   - log level (int)
    #
    def self.convert_level(level)
      level = level.upcase if level.is_a?(String)
      if level == 'DEBUG'
        return Logger::DEBUG
      elsif level == 'INFO'
        return Logger::INFO
      elsif level == 'WARN'
        return Logger::WARN
      elsif level == 'ERROR'
        return Logger::ERROR
      else
        raise 'illegal log level received'
      end
    end

    ########################
    def self.short_caller(string)
      File.basename(string)
    end
  end
end
