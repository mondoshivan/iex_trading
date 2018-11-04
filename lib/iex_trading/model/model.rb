
module IEX_Trading
  class Model

    ###################
    def to_s
      self.instance_variables.map{ |var|
        "#{var[1..-1]}=#{self.instance_variable_get(var)}"
      }.join("\n")
    end

  end
end