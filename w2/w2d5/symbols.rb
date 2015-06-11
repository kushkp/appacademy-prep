def super_print(string, options = {})
  defaults = {:times => 1, :upcase => false, :reverse => false}
  hash_values = defaults.merge(options)

  output = ""
  string.reverse! if hash_values[:reverse]
  string.upcase! if hash_values[:upcase]
  (hash_values[:times]).times { output << "#{string} " }
  output.strip!
end

#test
p super_print("Hello")  #=> "Hello"
p super_print("Hello", :times => 3)  #=> "Hello" 3x
p super_print("Hello", :upcase => true)  #=> "HELLO"
p super_print("Hello", :upcase => true, :reverse => true)  #=> "OLLEH"

options = {}
p super_print("hello", options)
