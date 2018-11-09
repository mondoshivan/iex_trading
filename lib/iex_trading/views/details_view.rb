require 'curses'

module IEX_Trading
  class DetailsView < View

    ###################
    def initialize(data=nil)
      super(data)

      @data = data
      @visible = true
      @interval = 1
    end

    ###################
    def print(x, y, string)
      Curses.setpos(y, x)
      Curses.addstr(string)
    end

    ###################
    def show_items
      @data.each {|item|
        print(item.x, item.y, item.string)
      }
    end

    public

    ###################
    def stop
      @visible = false
    end

    ###################
    def show
      Curses.init_screen
      Curses.crmode

      while @visible
        show_items
        Curses.refresh
        sleep @interval
      end
    end
  end
end