
module IEX_Trading
  class TableView

    ###################
    def initialize(data=nil)
      @data = data
      return if @data.nil?
      @data = @data.data
      @c_widths = column_widths(@data)
    end

    private

    ###################
    # get the max length for each column
    def column_widths(data)
      max = []
      data.each_with_index { |column, i|
        max_in_column = 0
        column.each {|record|
          record = record.to_s
          max_in_column = record.size if record.size > max_in_column
        }
        max[i] = max_in_column
      }
      max
    end

    ###################
    def create_row(columns, record_index)
      s = ''
      columns.times.each {|columns_index|
        padding = ' ' * (@c_widths[columns_index] - @data[columns_index][record_index].to_s.size)
        s += "#{@data[columns_index][record_index]} " + padding
      }
      s
    end

    public

    ###################
    def print
      return if @data.nil?
      header = 1
      records_size = @data[0].size - header
      columns = @data.size
      index_size = records_size.to_s.size > 'Index'.size ? records_size.to_s.size : 'Index'.size

      s = create_row(columns, 0)
      index_padding = ' ' * (index_size - 'Index'.size)
      header = 'Index ' + index_padding + s
      Log.print '-' * header.size + "\n"
      Log.print header + "\n"
      Log.print '-' * header.size + "\n"

      records_size.times.each {|record_index|
        record_index += 1
        s = create_row(columns, record_index)
        index_padding = ' ' * (index_size - record_index.to_s.size)
        Log.print "#{record_index}.#{index_padding}" + s + "\n"
      }
    end
  end
end
