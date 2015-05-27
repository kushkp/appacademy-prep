class Array
  def my_transpose
    transposed_array = []
    i = 0
    while i < self.length
      j = 0
      row = []
      while j < self[i].length
        row << self[j][i]
        j += 1
      end
      transposed_array << row
      i += 1
    end
    p transposed_array
  end
end

rows = [[0, 1, 2],[3, 4, 5],[6, 7, 8]]
columns = rows.my_transpose
new_rows = columns.my_transpose
