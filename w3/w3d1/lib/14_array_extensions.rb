class Array
  def sum
    self.inject(0) { |total, num| total += num}
  end

  def square
    self.map { |num| num * num }
  end

  def square!
    self.each_with_index do |num, idx|
      self[idx] = self[idx] * self[idx]
    end
  end

  # def square!
  #   map! { |num| num * num }
  # end

end
