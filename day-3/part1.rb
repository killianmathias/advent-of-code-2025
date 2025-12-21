# Function to open a file and transform it into an array
def open_file()
  array = []
  File.foreach("input.txt") do |line|
    array.push(line.chomp)
  end
  return array
end

# Calculate the biggest 2-digits number in a line in ascending order of indexes
def maximum_for_line(line)
  max = 0

  line.each_char.with_index do |char, index|
    if index == line.length - 1
      next
    end
    first = char.to_i
    max2 = 0
    newline = line[index + 1..-1]
    if newline
      newline.each_char do |char2|
        second = char2.to_i
        if second > max2
          max2 = second
        end
      end
    end

    result = 10 * first + max2
    if result > max
      max = result
    end
  end

  return max
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