
class Company

  attr_accessor :symbol
  attr_accessor :company_name
  attr_accessor :exchange
  attr_accessor :industry
  attr_accessor :website
  attr_accessor :description
  attr_accessor :ceo
  attr_accessor :issue_type
  attr_accessor :sector
  attr_accessor :tags

  ###################
  def to_s
    self.instance_variables.map{ |var|
      "#{var[1..-1]}=#{self.instance_variable_get(var)}"
    }.join("\n")
  end

end