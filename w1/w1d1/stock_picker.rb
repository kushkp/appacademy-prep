def stock_picker(arr)
  best_buy = 0
  best_sell = 0
  buydate = 0
  while buydate < arr.length - 1
    selldate = buydate + 1
    while selldate < arr.length
      if arr[selldate] - arr[buydate] > arr[best_sell] - arr[best_buy]
        best_buy = buydate
        best_sell = selldate
      end
      selldate += 1
    end
    buydate += 1
  end
  puts "It is best to buy on day #{best_buy} and sell on day #{best_sell}"
end

#test
stock_picker([30, 40, 50, 20, 80, 10, 20])
