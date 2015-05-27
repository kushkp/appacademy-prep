class Array
  def two_sum
    pairs = []
    i = 0
    while i < self.length - 1
      j = i + 1
      while j < self.length
        if self[i] + self[j] == 0
          pairs << [i,j]
        end
        j += 1
      end
      i += 1
    end
    p pairs
  end
end

myArray = [-1,2,4,-4,-2,1,-2,0,0]
puts (myArray.two_sum)
