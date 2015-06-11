require 'set'
require 'byebug'

def factors(x)
  nums = *(1..x)
  factors = nums.select {|num| x % num == 0}
end

def bubble_sort(arr)
  sorts = -1 #dummy value
  until sorts == 0
    sorts, pos = 0, 0
    (0...arr.length - 1).each do |pos|
      # byebug
      if arr[pos] > arr[pos + 1]
        arr[pos], arr[pos + 1] = arr[pos+1], arr[pos]
        sorts += 1
      end
    end
  end
end

def substrings(string)
  all_substrings = []
  (0...string.length).each do |start|
    (start...string.length).each do |ending|
      all_substrings << string.slice(start,ending-start+1)
    end
  end
  all_substrings
end

def subwords(string)
  words = Set.new(File.read("dictionary.txt").split("\n"))
  substrings(string).select { |substring| words.include?(substring) }
end
