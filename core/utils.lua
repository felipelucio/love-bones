local Utils = { class = "Utils" }

---Check if a value exists in a table array
---@param table table
---@param value any
---@return boolean
function Utils.tableContains(table, value)
  for _, v in ipairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

---Remove value if it exists in a table array
---@param table table
---@param value any
---@param count? integer
---@return table
function Utils.tableRemove(table, value, count)
  local c = 0
  local new = {}
  if not count or count <= 0 then
    count = math.huge
  end
  for _, v in ipairs(table) do
    if v == value and c <= count then
      c = c + 1
      goto continue
    end
    table.insert(new, v)
      ::continue::
  end
  return new
end

--- Copy values from one table to another
--- @param src table
--- @param dest table
function Utils.copy(src, dest)
  if src == nil then return nil end

  if type(src) == 'table' then
    for k, v in next, src, nil do
      dest[k] = v
    end
  else -- number, string, boolean, etc
    dest = src
  end
end

--- Create deep copy from tables
--- @param o table
--- @return table|nil
function Utils.deepcopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[Utils.deepcopy(k, seen)] = Utils.deepcopy(v, seen)
    end
    setmetatable(no, Utils.deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end

--- Clamp value to given range
function Utils.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end

---Returns -1 for negative, 0 for zero or 1 for positive numbers
---@param x number
---@return integer
function Utils.signum(x)
  return x>0 and 1 or x<0 and -1 or 0
end

function Utils.runFile(name)
	local ok, chunk, err = pcall(love.filesystem.load, name) -- load the chunk safely
	if not ok    then  return false, "Failed loading code: "..chunk  end
	if not chunk then  return false, "Failed reading file: "..err    end

	local ok, value = pcall(chunk) -- execute the chunk safely
	if not ok then  return false, "Failed calling chunk: "..tostring(value)  end

	return true, value -- success!
end

---Trim string whitespaces
---@param s string
---@return string, integer
function Utils.str_trim(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

---Check if string is empty
---@param s string
---@return boolean
function Utils.str_empty(s)
  s, _ = Utils.str_trim(s)
  return s == nil or s == ''
end

return Utils