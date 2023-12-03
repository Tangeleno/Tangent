function string.startsWith(self,start)
    return self:sub(1,#start) == start
end

--- Compares two strings, defaults to case insensitive
---@param self string
---@param compare string
---@param caseSentitive? boolean
function string.equals(self,compare,caseSentitive)
    if (self == nil and compare ~= nil) or (self ~= nil and compare == nil) then
        return false
    end
    if self == nil and compare == nil then
        return true
    end
    if caseSentitive then
        return self == compare
    else
        return self:lower() == compare:lower()
    end
end

function string.endsWith(self, ending)
    if self == nil then
        return false
    end
    return ending == "" or self:sub(-#ending) == ending
 end