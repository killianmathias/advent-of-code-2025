# Function to open a file and transform it into an array
def open_file()
  array = []
  File.foreach("input.txt") do |line|
    array.push(line.chomp)
  end
  return array
end

# Calculate the biggest 12-digits number in a line in ascending order of indexes
def maximum_for_line(line)
  result = ""
  start_index = 0
  length = line.size

  12.times do |i|
    rest = 12 - i

    max_index = length - rest
    subline = line[start_index..max_index]

    max = subline[0]
    subline.each_char do |c|
      if c > max
        max = c
      end
    end

    result += max

    index_subline = subline.index(max)
    start_index = start_index + index_subline + 1
  end

  return result.to_i
end

# Function that calculate the sum of each maximum_for_line for each line of an array
def calculate_sum(file)
  sum = 0
  file.each_with_index do |line,index|
    p(index)
    sum += maximum_for_line(line)
   
  end
  return sum
end

# Final result
file = open_file()
result = calculate_sum(file)
p(result)