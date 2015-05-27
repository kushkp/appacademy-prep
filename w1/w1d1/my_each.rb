class Array
  def my_each (&block)
    i = 0
    while i < self.length
      block.call(self[i])
      i += 1
    end
    self
  end
end

#test
return_value = [1, 2, 3].my_each do |num|
  puts num*2
end.my_each do |num|
  puts num*2
end
p return_value # => [1, 2, 3]
