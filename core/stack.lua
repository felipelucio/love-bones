---@class Stack
---@field stack table
local Stack = {}
Stack.__index = Stack

---Constructor
---@return Stack
function Stack.new()
    local o = setmetatable({
        stack = {},
    }, Stack)
    return o
end

---Add item
---@param item any
function Stack:add(item)
    table.insert(self.stack, item)
end

---Remove item from stack
---@param item any
function Stack:remove(item)
    local idx = -1
    for i = 1, #self.stack do
        if self.stack[i].id == item.id then
           idx = i
           break
        end
    end
    if idx > 0 then
        table.remove(self.stack, idx)
    end
end

---Pop item from the top of stack
---@return any
function Stack:pop()
    return self.stack[#self.stack]
end

return Stack