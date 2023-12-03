---@type deque
local deque = {}

function deque.new(name)
    ---@class deque
    local self = {}
    local first = 0
    local last = -1
    local list = {}
    ---@generic T
    ---@param value T
    function self.PushFront(value)
        first = first - 1
        list[first] = value
    end
    ---@generic T
    ---@param value T
    function self.PushBack(value)
        last = last + 1
        list[last] = value
    end

    function self.Size()
        if first > last then
            return 0
        end
        return last - first + 1
    end
    ---@generic T
    ---@return T
    function self.PopFront()
        if first > last then
            return nil
        end
        local value = list[first]
        list[first] = nil
        first = first + 1
        return value
    end
    ---@generic T
    ---@return T
    function self.PopBack()
        if first > last then
            return nil
        end
        local value = list[last]
        list[last] = nil
        last = last - 1
        return value
    end
    ---@generic T
    ---@return T
    function self.PeekFront()
        if first > last then
            return nil
        end
        return list[first]
    end
    ---@generic T
    ---@return T
    function self.PeekBack()
        if first > last then
            return nil
        end
        return list[last]
    end

    function self.IsEmpty()
        return first > last
    end

    function self.Empty()
        while first <= last do
            self.PopFront();
        end
    end

    return self
end

return deque
