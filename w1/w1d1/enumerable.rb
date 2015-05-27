def doubleArray(arr)
  arr.map {|i| 2*i}
end

def median(arr)
  arr.sort!
  mid = arr.length/2

  if arr.length % 2 == 1
    value = arr[mid]
  else
    mid
    arr[mid]
    arr[mid+1]
    value = (arr[mid-1] + arr[mid]) / 2
  end

  value
end

def concatString(arr)
  arr.inject("") do |entire_string, word|
    entire_string + word
  end
end

#test
# p doubleArray [1,5,10,20]

# p median [10,4,99,40,1]
# p median [10,4,99,40]

# p concatString ["Yay ", "for ", "strings!"]
