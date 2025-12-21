--Opening the file

local file, error = io.open("input.txt","r")

if not file then
    print("Erreur :" .. error)
    return
end

local file_content = file:read("*a")

-- Function to split a String with a separator
local function split(string,separator)
    local result = {}
    for part in string.gmatch(string, "([^" .. separator .. "]+)") do
        table.insert(result, part)
    end
    return result
end

-- Function which scan if a string is composed of at least two occurences of a pattern
local function is_pattern(str)
  local string_len = #str

  for length = 1, math.floor(string_len / 2) do
    if string_len % length == 0 then
      local pattern = str:sub(1, length)
      local rep = pattern:rep(string_len / length)

      if rep == str then
        return true
      end
    end
  end

  return false
end

-- Calculate the sum of all the number composed of repeated pattern
local function calculate_sum(file_content)
    local first_split = split(file_content, ",")
    local total = 0
    for index, value in ipairs(first_split) do
        local second_split = split(value, "-");
        for i =tonumber(second_split[1]),  tonumber(second_split[2]) do 
            local str = tostring(i)
            if is_pattern(str) then
                total = total +i
            end

        end
    end
    return total
end

-- Final result
local result = calculate_sum(file_content)
print(result)

file:close()