class Variable
  def ==(other)
    @last = other
    true
  end

  def variable?
    true
  end

  def values
    @last ? [@last] : []
  end
end
