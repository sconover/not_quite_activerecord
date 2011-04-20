class Numeric
  def precision(digits)
    result = "%.#{digits}f" % self
    str = result.to_f.to_s
    
    extra_zeroes = "0" * (digits - str.split(".")[1].length)
    str << extra_zeroes
    str
  end
end