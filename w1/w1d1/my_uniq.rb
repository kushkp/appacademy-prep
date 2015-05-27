class Array
  def my_uniq
    uniques = []
    self.each do |num|
      if !uniques.include?(num)
        uniques << num
      end
    end
    uniques
  end
end

myArray = [1,2,3,2,3,8,1,5]
puts (myArray.my_uniq)
