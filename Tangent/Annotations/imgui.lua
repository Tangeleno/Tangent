---@diagnostic disable: duplicate-index, undefined-doc-name, missing-return
--- ImGui
---@class ImGui
ImGui = {
    ---@return boolean
    ---@param name string
    ["Begin"] = function(name)end,
    ---@return boolean, boolean
    ---@param name string
    ---@param open boolean
    ["Begin"] = function(name,open)end,
    ---@return boolean, boolean
    ---@param name string
    ---@param open boolean
    ---@param flags number int
    ["Begin"] = function(name,open,flags)end,
    ["End"] = function()end,
    ---@return boolean
    ---@param name string
    ---@param sizeX? number
    ---@param sizeY? number
    ---@param border? boolean
    ---@param flags? number int
    ["BeginChild"] = function(name,sizeX,sizeY,border,flags)end,
    ["EndChild"] = function()end,
    ---@return boolean
    ["IsWindowAppearing"] = function()end,
    ---@return boolean
    ["IsWindowCollapsed"] = function()end,
    ---@return boolean
    ["IsWindowFocused"] = function()end,
    ---@return boolean
    ---@param flags number int
    ["IsWindowFocused"] = function(flags)end,
    ---@return boolean
    ["IsWindowHovered"] = function()end,
    ---@return boolean
    ---@param flags number int
    ["IsWindowHovered"] = function(flags)end,
    ---@return ImDrawList
    ["GetWindowDrawList"] = function()end,
    ---@return number
    ["GetWindowDpiScale"] = function()end,
    ---@return ImGuiViewport
    ["GetWindowViewport"] = function()end,
    ---@return number, number
    ["GetWindowPos"] = function()end,
    ---@return number, number
    ["GetWindowSize"] = function()end,
    ---@return number
    ["GetWindowWidth"] = function()end,
    ---@return number
    ["GetWindowHeight"] = function()end,
    ---@param posX number
    ---@param posY number
    ["SetNextWindowPos"] = function(posX,posY)end,
    ---@param posX number
    ---@param posY number
    ---@param cond number int
    ["SetNextWindowPos"] = function(posX,posY,cond)end,
    ---@param posX number
    ---@param posY number
    ---@param cond number int
    ---@param pivotX number
    ---@param pivotY number
    ["SetNextWindowPos"] = function(posX,posY,cond,pivotX,pivotY)end,
    ---@param sizeX number
    ---@param sizeY number
    ["SetNextWindowSize"] = function(sizeX,sizeY)end,
    ---@param sizeX number
    ---@param sizeY number
    ---@param cond number int
    ["SetNextWindowSize"] = function(sizeX,sizeY,cond)end,
    ---@param minX number
    ---@param minY number
    ---@param maxX number
    ---@param maxY number
    ["SetNextWindowSizeConstraints"] = function(minX,minY,maxX,maxY)end,
    ---@param sizeX number
    ---@param sizeY number
    ["SetNextWindowContentSize"] = function(sizeX,sizeY)end,
    ---@param collapsed boolean
    ["SetNextWindowCollapsed"] = function(collapsed)end,
    ---@param collapsed boolean
    ---@param cond number int
    ["SetNextWindowCollapsed"] = function(collapsed,cond)end,
    ["SetNextWindowFocus"] = function()end,
    ---@param alpha number
    ["SetNextWindowBgAlpha"] = function(alpha)end,
    ---@param posX number
    ---@param posY number
    ["SetWindowPos"] = function(posX,posY)end,
    ---@param posX number
    ---@param posY number
    ---@param cond number int
    ["SetWindowPos"] = function(posX,posY,cond)end,
    ---@param sizeX number
    ---@param sizeY number
    ["SetWindowSize"] = function(sizeX,sizeY)end,
    ---@param sizeX number
    ---@param sizeY number
    ---@param cond number int
    ["SetWindowSize"] = function(sizeX,sizeY,cond)end,
    ---@param collapsed boolean
    ["SetWindowCollapsed"] = function(collapsed)end,
    ---@param collapsed boolean
    ---@param cond number int
    ["SetWindowCollapsed"] = function(collapsed,cond)end,
    ["SetWindowFocus"] = function()end,
    ---@param scale number
    ["SetWindowFontScale"] = function(scale)end,
    ---@param name string
    ---@param posX number
    ---@param posY number
    ["SetWindowPos"] = function(name,posX,posY)end,
    ---@param name string
    ---@param posX number
    ---@param posY number
    ---@param cond number int
    ["SetWindowPos"] = function(name,posX,posY,cond)end,
    ---@param name string
    ---@param sizeX number
    ---@param sizeY number
    ["SetWindowSize"] = function(name,sizeX,sizeY)end,
    ---@param name string
    ---@param sizeX number
    ---@param sizeY number
    ---@param cond number int
    ["SetWindowSize"] = function(name,sizeX,sizeY,cond)end,
    ---@param name string
    ---@param collapsed boolean
    ["SetWindowCollapsed"] = function(name,collapsed)end,
    ---@param name string
    ---@param collapsed boolean
    ---@param cond number int
    ["SetWindowCollapsed"] = function(name,collapsed,cond)end,
    ---@param name string
    ["SetWindowFocus"] = function(name)end,
    ---@return number, number
    ["GetContentRegionMax"] = function()end,
    ---@return number, number
    ["GetContentRegionAvail"] = function()end,
    ---@return number, number
    ["GetWindowContentRegionMin"] = function()end,
    ---@return number, number
    ["GetWindowContentRegionMax"] = function()end,
    ---@return number
    ["GetWindowContentRegionWidth"] = function()end,
    ---@return number
    ["GetScrollX"] = function()end,
    ---@return number
    ["GetScrollY"] = function()end,
    ---@return number
    ["GetScrollMaxX"] = function()end,
    ---@return number
    ["GetScrollMaxY"] = function()end,
    ---@param scrollX number
    ["SetScrollX"] = function(scrollX)end,
    ---@param scrollY number
    ["SetScrollY"] = function(scrollY)end,
    ["SetScrollHereX"] = function()end,
    ---@param centerXRatio number
    ["SetScrollHereX"] = function(centerXRatio)end,
    ["SetScrollHereY"] = function()end,
    ---@param centerYRatio number
    ["SetScrollHereY"] = function(centerYRatio)end,
    ---@param localX number
    ["SetScrollFromPosX"] = function(localX)end,
    ---@param localX number
    ---@param centerXRatio number
    ["SetScrollFromPosX"] = function(localX,centerXRatio)end,
    ---@param localY number
    ["SetScrollFromPosY"] = function(localY)end,
    ---@param localY number
    ---@param centerYRatio number
    ["SetScrollFromPosY"] = function(localY,centerYRatio)end,
    ---@param pFont ImFont
    ["PushFont"] = function(pFont)end,
    ["PopFont"] = function()end,
    ---@param idx number int
    ---@param col number int
    ["PushStyleColor"] = function(idx,col)end,
    ---@param idx number int
    ---@param colR number
    ---@param colG number
    ---@param colB number
    ---@param colA number
    ["PushStyleColor"] = function(idx,colR,colG,colB,colA)end,
    ["PopStyleColor"] = function()end,
    ---@param count number int
    ["PopStyleColor"] = function(count)end,
    ---@param idx number int
    ---@param val number
    ["PushStyleVar"] = function(idx,val)end,
    ---@param idx number int
    ---@param valX number
    ---@param valY number
    ["PushStyleVar"] = function(idx,valX,valY)end,
    ["PopStyleVar"] = function()end,
    ---@param count number int
    ["PopStyleVar"] = function(count)end,
    ---@return number, number, number, number
    ---@param idx number int
    ["GetStyleColorVec4"] = function(idx)end,
    ---@return ImFont
    ["GetFont"] = function()end,
    ---@return number
    ["GetFontSize"] = function()end,
    ---@return number, number
    ["GetFontTexUvWhitePixel"] = function()end,
    ---@return number int
    ---@param idx number int
    ---@param alphaMul number
    ["GetColorU32"] = function(idx,alphaMul)end,
    ---@return number int
    ---@param colR number
    ---@param colG number
    ---@param colB number
    ---@param colA number
    ["GetColorU32"] = function(colR,colG,colB,colA)end,
    ---@return number int
    ---@param col number int
    ["GetColorU32"] = function(col)end,
    ---@param itemWidth number
    ["PushItemWidth"] = function(itemWidth)end,
    ["PopItemWidth"] = function()end,
    ---@param itemWidth number
    ["SetNextItemWidth"] = function(itemWidth)end,
    ---@return number
    ["CalcItemWidth"] = function()end,
    ["PushTextWrapPos"] = function()end,
    ---@param wrapLocalPosX number
    ["PushTextWrapPos"] = function(wrapLocalPosX)end,
    ["PopTextWrapPos"] = function()end,
    ---@param allowKeyboardFocus boolean
    ["PushAllowKeyboardFocus"] = function(allowKeyboardFocus)end,
    ["PopAllowKeyboardFocus"] = function()end,
    ---@param shouldRepeat boolean
    ["PushButtonRepeat"] = function(shouldRepeat)end,
    ["PopButtonRepeat"] = function()end,
    ["Separator"] = function()end,
    ["SameLine"] = function()end,
    ---@param offsetFromStartX number
    ["SameLine"] = function(offsetFromStartX)end,
    ---@param offsetFromStartX number
    ---@param spacing number
    ["SameLine"] = function(offsetFromStartX,spacing)end,
    ["NewLine"] = function()end,
    ["Spacing"] = function()end,
    ---@param sizeX number
    ---@param sizeY number
    ["Dummy"] = function(sizeX,sizeY)end,
    ["Indent"] = function()end,
    ---@param indentW number
    ["Indent"] = function(indentW)end,
    ["Unindent"] = function()end,
    ---@param indentW number
    ["Unindent"] = function(indentW)end,
    ["BeginGroup"] = function()end,
    ["EndGroup"] = function()end,
    ---@return number, number
    ["GetCursorPos"] = function()end,
    ---@return number
    ["GetCursorPosX"] = function()end,
    ---@return number
    ["GetCursorPosY"] = function()end,
    ---@param localX number
    ---@param localY number
    ["SetCursorPos"] = function(localX,localY)end,
    ---@param localX number
    ["SetCursorPosX"] = function(localX)end,
    ---@param localY number
    ["SetCursorPosY"] = function(localY)end,
    ---@return number, number
    ["GetCursorStartPos"] = function()end,
    ---@return number, number
    ["GetCursorScreenPos"] = function()end,
    ---@param posX number
    ---@param posY number
    ["SetCursorScreenPos"] = function(posX,posY)end,
    ["AlignTextToFramePadding"] = function()end,
    ---@return number
    ["GetTextLineHeight"] = function()end,
    ---@return number
    ["GetTextLineHeightWithSpacing"] = function()end,
    ---@return number
    ["GetFrameHeight"] = function()end,
    ---@return number
    ["GetFrameHeightWithSpacing"] = function()end,
    ---@param stringID string
    ["PushID"] = function(stringID)end,
    ---@param stringIDBegin string
    ---@param stringIDEnd string
    ["PushID"] = function(stringIDBegin,stringIDEnd)end,
    ---@param any any
    ["PushID"] = function(any)end,
    ---@param intID number int
    ["PushID"] = function(intID)end,
    ["PopID"] = function()end,
    ---@return number int
    ---@param stringID string
    ["GetID"] = function(stringID)end,
    ---@return number int
    ---@param stringIDBegin string
    ---@param stringIDEnd string
    ["GetID"] = function(stringIDBegin,stringIDEnd)end,
    ---@return number int
    ---@param any any
    ["GetID"] = function(any)end,
    ---@param text string
    ["TextUnformatted"] = function(text)end,
    ---@param text string
    ---@param textEnd string
    ["TextUnformatted"] = function(text,textEnd)end,
    ---@param text string
    ["Text"] = function(text)end,
    ---@param colR number
    ---@param colG number
    ---@param colB number
    ---@param colA number
    ---@param text string
    ["TextColored"] = function(colR,colG,colB,colA,text)end,
    ---@param text string
    ["TextDisabled"] = function(text)end,
    ---@param text string
    ["TextWrapped"] = function(text)end,
    ---@param label string
    ---@param text string
    ["LabelText"] = function(label,text)end,
    ---@param text string
    ["BulletText"] = function(text)end,
    ---@return boolean
    ---@param label string
    ["Button"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ["Button"] = function(label,sizeX,sizeY)end,
    ---@return boolean
    ---@param label string
    ["SmallButton"] = function(label)end,
    ---@return boolean
    ---@param stringID string
    ---@param sizeX number
    ---@param sizeY number
    ["InvisibleButton"] = function(stringID,sizeX,sizeY)end,
    ---@return boolean
    ---@param stringID string
    ---@param dir number int
    ["ArrowButton"] = function(stringID,dir)end,
    ["Image"] = function()end,
    ["ImageButton"] = function()end,
    ---@return boolean, boolean
    ---@param label string
    ---@param v boolean
    ["Checkbox"] = function(label,v)end,
    ---@return boolean
    ["CheckboxFlags"] = function()end,
    ---@return boolean
    ---@param label string
    ---@param active boolean
    ["RadioButton"] = function(label,active)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param vButton number int
    ["RadioButton"] = function(label,v,vButton)end,
    ---@param fraction number
    ["ProgressBar"] = function(fraction)end,
    ---@param fraction number
    ---@param sizeX number
    ---@param sizeY number
    ["ProgressBar"] = function(fraction,sizeX,sizeY)end,
    ---@param fraction number
    ---@param sizeX number
    ---@param sizeY number
    ---@param overlay string
    ["ProgressBar"] = function(fraction,sizeX,sizeY,overlay)end,
    ["Bullet"] = function()end,
    ---@return boolean
    ---@param label string
    ---@param previewValue string
    ["BeginCombo"] = function(label,previewValue)end,
    ---@return boolean
    ---@param label string
    ---@param previewValue string
    ---@param flags number int
    ["BeginCombo"] = function(label,previewValue,flags)end,
    ["EndCombo"] = function()end,
    ---@return number int, boolean
    ---@param label string
    ---@param currentItem number int
    ---@param items table
    ---@param itemsCount number int
    ["Combo"] = function(label,currentItem,items,itemsCount)end,
    ---@return number int, boolean
    ---@param label string
    ---@param currentItem number int
    ---@param items table
    ---@param itemsCount number int
    ---@param popupMaxHeightInItems number int
    ["Combo"] = function(label,currentItem,items,itemsCount,popupMaxHeightInItems)end,
    ---@return number int, boolean
    ---@param label string
    ---@param currentItem number int
    ---@param itemsSeparatedByZeros string
    ["Combo"] = function(label,currentItem,itemsSeparatedByZeros)end,
    ---@return number int, boolean
    ---@param label string
    ---@param currentItem number int
    ---@param itemsSeparatedByZeros string
    ---@param popupMaxHeightInItems number int
    ["Combo"] = function(label,currentItem,itemsSeparatedByZeros,popupMaxHeightInItems)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ["DragFloat"] = function(label,v)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_speed number
    ["DragFloat"] = function(label,v,v_speed)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_speed number
    ---@param v_min number
    ["DragFloat"] = function(label,v,v_speed,v_min)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ["DragFloat"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["DragFloat"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["DragFloat"] = function(label,v,v_speed,v_min,v_max,format,power)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ["DragFloat2"] = function(label,v)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ["DragFloat2"] = function(label,v,v_speed)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ["DragFloat2"] = function(label,v,v_speed,v_min)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ["DragFloat2"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["DragFloat2"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["DragFloat2"] = function(label,v,v_speed,v_min,v_max,format,power)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ["DragFloat3"] = function(label,v)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ["DragFloat3"] = function(label,v,v_speed)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ["DragFloat3"] = function(label,v,v_speed,v_min)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ["DragFloat3"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["DragFloat3"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["DragFloat3"] = function(label,v,v_speed,v_min,v_max,format,power)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ["DragFloat4"] = function(label,v)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ["DragFloat4"] = function(label,v,v_speed)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ["DragFloat4"] = function(label,v,v_speed,v_min)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ["DragFloat4"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["DragFloat4"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["DragFloat4"] = function(label,v,v_speed,v_min,v_max,format,power)end,
    ["DragFloatRange2"] = function()end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ["DragInt"] = function(label,v)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param v_speed number
    ["DragInt"] = function(label,v,v_speed)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param v_speed number
    ---@param v_min number int
    ["DragInt"] = function(label,v,v_speed,v_min)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ["DragInt"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["DragInt"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ["DragInt2"] = function(label,v)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ["DragInt2"] = function(label,v,v_speed)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ["DragInt2"] = function(label,v,v_speed,v_min)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ["DragInt2"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["DragInt2"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ["DragInt3"] = function(label,v)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ["DragInt3"] = function(label,v,v_speed)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ["DragInt3"] = function(label,v,v_speed,v_min)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ["DragInt3"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["DragInt3"] = function(label,v,v_speed,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ["DragInt4"] = function(label,v)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ["DragInt4"] = function(label,v,v_speed)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ["DragInt4"] = function(label,v,v_speed,v_min)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ["DragInt4"] = function(label,v,v_speed,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_speed number
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["DragInt4"] = function(label,v,v_speed,v_min,v_max,format)end,
    ["DragIntRange2"] = function()end,
    ["DragScalar"] = function()end,
    ["DragScalarN"] = function()end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_min number
    ---@param v_max number
    ["SliderFloat"] = function(label,v,v_min,v_max)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["SliderFloat"] = function(label,v,v_min,v_max,format)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["SliderFloat"] = function(label,v,v_min,v_max,format,power)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ["SliderFloat2"] = function(label,v,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["SliderFloat2"] = function(label,v,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["SliderFloat2"] = function(label,v,v_min,v_max,format,power)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ["SliderFloat3"] = function(label,v,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["SliderFloat3"] = function(label,v,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["SliderFloat3"] = function(label,v,v_min,v_max,format,power)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ["SliderFloat4"] = function(label,v,v_min,v_max)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["SliderFloat4"] = function(label,v,v_min,v_max,format)end,
    ---@return number[], boolean
    ---@param label string
    ---@param v table
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number
    ["SliderFloat4"] = function(label,v,v_min,v_max,format,power)end,
    ---@return number, boolean
    ---@param label string
    ---@param v_rad number
    ["SliderAngle"] = function(label,v_rad)end,
    ---@return number, boolean
    ---@param label string
    ---@param v_rad number
    ---@param v_degrees_min number
    ["SliderAngle"] = function(label,v_rad,v_degrees_min)end,
    ---@return number, boolean
    ---@param label string
    ---@param v_rad number
    ---@param v_degrees_min number
    ---@param v_degrees_max number
    ["SliderAngle"] = function(label,v_rad,v_degrees_min,v_degrees_max)end,
    ---@return number, boolean
    ---@param label string
    ---@param v_rad number
    ---@param v_degrees_min number
    ---@param v_degrees_max number
    ---@param format string
    ["SliderAngle"] = function(label,v_rad,v_degrees_min,v_degrees_max,format)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param v_min number int
    ---@param v_max number int
    ["SliderInt"] = function(label,v,v_min,v_max)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["SliderInt"] = function(label,v,v_min,v_max,format)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v table
    ---@param v_min number int
    ---@param v_max number int
    ["SliderInt2"] = function(label,v,v_min,v_max)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v table
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["SliderInt2"] = function(label,v,v_min,v_max,format)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v table
    ---@param v_min number int
    ---@param v_max number int
    ["SliderInt3"] = function(label,v,v_min,v_max)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v table
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["SliderInt3"] = function(label,v,v_min,v_max,format)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v table
    ---@param v_min number int
    ---@param v_max number int
    ["SliderInt4"] = function(label,v,v_min,v_max)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v table
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["SliderInt4"] = function(label,v,v_min,v_max,format)end,
    ["SliderScalar"] = function()end,
    ["SliderScalarN"] = function()end,
    ---@return number, boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ---@param v number
    ---@param v_min number
    ---@param v_max number
    ["VSliderFloat"] = function(label,sizeX,sizeY,v,v_min,v_max)end,
    ---@return number, boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ---@param v number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ["VSliderFloat"] = function(label,sizeX,sizeY,v,v_min,v_max,format)end,
    ---@return number, boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ---@param v number
    ---@param v_min number
    ---@param v_max number
    ---@param format string
    ---@param power number int
    ["VSliderFloat"] = function(label,sizeX,sizeY,v,v_min,v_max,format,power)end,
    ---@return number int, boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ---@param v number int
    ---@param v_min number int
    ---@param v_max number int
    ["VSliderInt"] = function(label,sizeX,sizeY,v,v_min,v_max)end,
    ---@return number int, boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ---@param v number int
    ---@param v_min number int
    ---@param v_max number int
    ---@param format string
    ["VSliderInt"] = function(label,sizeX,sizeY,v,v_min,v_max,format)end,
    ["VSliderScalar"] = function()end,
    ---@return string, boolean
    ---@param label string
    ---@param text string
    ["InputText"] = function(label,text)end,
    ---@return string, boolean
    ---@param label string
    ---@param text string
    ---@param flags number int
    ["InputText"] = function(label,text,flags)end,
    ---@return string, boolean
    ---@param label string
    ---@param text string
    ["InputTextMultiline"] = function(label,text)end,
    ---@return string, boolean
    ---@param label string
    ---@param text string
    ---@param sizeX number
    ---@param sizeY number
    ["InputTextMultiline"] = function(label,text,sizeX,sizeY)end,
    ---@return string, boolean
    ---@param label string
    ---@param text string
    ---@param sizeX number
    ---@param sizeY number
    ---@param flags number int
    ["InputTextMultiline"] = function(label,text,sizeX,sizeY,flags)end,
    ---@return string, boolean
    ---@param label string
    ---@param hint string
    ---@param text string
    ["InputTextWithHint"] = function(label,hint,text)end,
    ---@return string, boolean
    ---@param label string
    ---@param hint string
    ---@param text string
    ---@param flags number int
    ["InputTextWithHint"] = function(label,hint,text,flags)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ["InputFloat"] = function(label,v)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ["InputFloat"] = function(label,v,step)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ---@param step_fast number
    ["InputFloat"] = function(label,v,step,step_fast)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ---@param step_fast number
    ---@param format string
    ["InputFloat"] = function(label,v,step,step_fast,format)end,
    ---@return number, boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ---@param step_fast number
    ---@param format string
    ---@param flags number int
    ["InputFloat"] = function(label,v,step,step_fast,format,flags)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ["InputFloat2"] = function(label,v)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param format string
    ["InputFloat2"] = function(label,v,format)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param format string
    ---@param flags number int
    ["InputFloat2"] = function(label,v,format,flags)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ["InputFloat3"] = function(label,v)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param format string
    ["InputFloat3"] = function(label,v,format)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param format string
    ---@param flags number int
    ["InputFloat3"] = function(label,v,format,flags)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ["InputFloat4"] = function(label,v)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param format string
    ["InputFloat4"] = function(label,v,format)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param format string
    ---@param flags number int
    ["InputFloat4"] = function(label,v,format,flags)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ["InputInt"] = function(label,v)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param step number int
    ["InputInt"] = function(label,v,step)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param step number int
    ---@param step_fast number int
    ["InputInt"] = function(label,v,step,step_fast)end,
    ---@return number int, boolean
    ---@param label string
    ---@param v number int
    ---@param step number int
    ---@param step_fast number int
    ---@param flags number int
    ["InputInt"] = function(label,v,step,step_fast,flags)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ["InputInt2"] = function(label,v)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param flags number int
    ["InputInt2"] = function(label,v,flags)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ["InputInt3"] = function(label,v)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param flags number int
    ["InputInt3"] = function(label,v,flags)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ["InputInt4"] = function(label,v)end,
    ---@return number[],boolean
    ---@param label string
    ---@param v table
    ---@param flags number int
    ["InputInt4"] = function(label,v,flags)end,
    ---@return number,boolean
    ---@param label string
    ---@param v number
    ["InputDouble"] = function(label,v)end,
    ---@return number,boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ["InputDouble"] = function(label,v,step)end,
    ---@return number,boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ---@param step_fast number
    ["InputDouble"] = function(label,v,step,step_fast)end,
    ---@return number,boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ---@param step_fast number
    ---@param format string
    ["InputDouble"] = function(label,v,step,step_fast,format)end,
    ---@return number,boolean
    ---@param label string
    ---@param v number
    ---@param step number
    ---@param step_fast number
    ---@param format string
    ---@param flags number int
    ["InputDouble"] = function(label,v,step,step_fast,format,flags)end,
    ["InputScalar"] = function()end,
    ["InputScalarN"] = function()end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ["ColorEdit3"] = function(label,col)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ---@param flags number int
    ["ColorEdit3"] = function(label,col,flags)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ["ColorEdit4"] = function(label,col)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ---@param flags number int
    ["ColorEdit4"] = function(label,col,flags)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ["ColorPicker3"] = function(label,col)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ---@param flags number int
    ["ColorPicker3"] = function(label,col,flags)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ["ColorPicker4"] = function(label,col)end,
    ---@return number[], boolean
    ---@param label string
    ---@param col table
    ---@param flags number int
    ["ColorPicker4"] = function(label,col,flags)end,
    ---@return boolean
    ---@param desc_id string
    ---@param col table
    ["ColorButton"] = function(desc_id,col)end,
    ---@return boolean
    ---@param desc_id string
    ---@param col table
    ---@param flags number int
    ["ColorButton"] = function(desc_id,col,flags)end,
    ---@return boolean
    ---@param desc_id string
    ---@param col table
    ---@param flags number int
    ---@param sizeX number
    ---@param sizeY number
    ["ColorButton"] = function(desc_id,col,flags,sizeX,sizeY)end,
    ---@param flags number int
    ["SetColorEditOptions"] = function(flags)end,
    ---@return boolean
    ---@param label string
    ["TreeNode"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param fmt string
    ["TreeNode"] = function(label,fmt)end,
    ---@return boolean
    ---@param label string
    ["TreeNodeEx"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param flags number int
    ["TreeNodeEx"] = function(label,flags)end,
    ---@return boolean
    ---@param label string
    ---@param flags number int
    ---@param fmt string
    ["TreeNodeEx"] = function(label,flags,fmt)end,
    ---@param str_id string
    ["TreePush"] = function(str_id)end,
    ["TreePop"] = function()end,
    ---@return number
    ["GetTreeNodeToLabelSpacing"] = function()end,
    ---@return boolean
    ---@param label string
    ["CollapsingHeader"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param flags number int
    ["CollapsingHeader"] = function(label,flags)end,
    ---@return boolean, boolean
    ---@param label string
    ---@param open boolean
    ["CollapsingHeader"] = function(label,open)end,
    ---@return boolean, boolean
    ---@param label string
    ---@param open boolean
    ---@param flags number int
    ["CollapsingHeader"] = function(label,open,flags)end,
    ---@param is_open boolean
    ["SetNextItemOpen"] = function(is_open)end,
    ---@param is_open boolean
    ---@param cond number int
    ["SetNextItemOpen"] = function(is_open,cond)end,
    ---@return boolean
    ---@param label string
    ["Selectable"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param selected boolean
    ["Selectable"] = function(label,selected)end,
    ---@return boolean
    ---@param label string
    ---@param selected boolean
    ---@param flags number int
    ["Selectable"] = function(label,selected,flags)end,
    ---@return boolean
    ---@param label string
    ---@param selected boolean
    ---@param flags number int
    ---@param sizeX number
    ---@param sizeY number
    ["Selectable"] = function(label,selected,flags,sizeX,sizeY)end,
    ---@return number int, boolean
    ---@param label string
    ---@param current_item number int
    ---@param items table
    ---@param items_count number int
    ["ListBox"] = function(label,current_item,items,items_count)end,
    ---@return number int, boolean
    ---@param label string
    ---@param current_item number int
    ---@param items table
    ---@param items_count number int
    ---@param height_in_items number int
    ["ListBox"] = function(label,current_item,items,items_count,height_in_items)end,
    ---@return boolean
    ---@param label string
    ---@param sizeX number
    ---@param sizeY number
    ["ListBoxHeader"] = function(label,sizeX,sizeY)end,
    ---@return boolean
    ---@param label string
    ---@param items_count number int
    ["ListBoxHeader"] = function(label,items_count)end,
    ---@return boolean
    ---@param label string
    ---@param items_count number int
    ---@param height_in_items number int
    ["ListBoxHeader"] = function(label,items_count,height_in_items)end,
    ["ListBoxFooter"] = function()end,
    ---@param prefix string
    ---@param b boolean
    ["Value"] = function(prefix,b)end,
    ---@param prefix string
    ---@param v number int
    ["Value"] = function(prefix,v)end,
    ---@param prefix string
    ---@param v number uint
    ["Value"] = function(prefix,v)end,
    ---@param prefix string
    ---@param v number
    ["Value"] = function(prefix,v)end,
    ---@param prefix string
    ---@param v number
    ---@param float_format string
    ["Value"] = function(prefix,v,float_format)end,
    ---@return boolean
    ["BeginMenuBar"] = function()end,
    ["EndMenuBar"] = function()end,
    ---@return boolean
    ["BeginMainMenuBar"] = function()end,
    ["EndMainMenuBar"] = function()end,
    ---@return boolean
    ---@param label string
    ["BeginMenu"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param enabled boolean
    ["BeginMenu"] = function(label,enabled)end,
    ["EndMenu"] = function()end,
    ---@return boolean
    ---@param label string
    ["MenuItem"] = function(label)end,
    ---@return boolean
    ---@param label string
    ---@param shortcut string
    ["MenuItem"] = function(label,shortcut)end,
    ---@return boolean, boolean
    ---@param label string
    ---@param shortcut string
    ---@param selected boolean
    ["MenuItem"] = function(label,shortcut,selected)end,
    ---@return boolean, boolean
    ---@param label string
    ---@param shortcut string
    ---@param selected boolean
    ---@param enabled boolean
    ["MenuItem"] = function(label,shortcut,selected,enabled)end,
    ["BeginTooltip"] = function()end,
    ["EndTooltip"] = function()end,
    ---@param fmt string
    ["SetTooltip"] = function(fmt)end,
    ["SetTooltipV"] = function()end,
    ---@return boolean
    ---@param str_id string
    ["BeginPopup"] = function(str_id)end,
    ---@return boolean
    ---@param str_id string
    ---@param flags number int
    ["BeginPopup"] = function(str_id,flags)end,
    ---@return boolean
    ---@param name string
    ["BeginPopupModal"] = function(name)end,
    ---@return boolean
    ---@param name string
    ---@param open boolean
    ["BeginPopupModal"] = function(name,open)end,
    ---@return boolean
    ---@param name string
    ---@param open boolean
    ---@param flags number int
    ["BeginPopupModal"] = function(name,open,flags)end,
    ["EndPopup"] = function()end,
    ---@param str_id string
    ["OpenPopup"] = function(str_id)end,
    ---@param str_id string
    ---@param popup_flags number int
    ["OpenPopup"] = function(str_id,popup_flags)end,
    ["CloseCurrentPopup"] = function()end,
    ---@return boolean
    ["BeginPopupContextItem"] = function()end,
    ---@return boolean
    ---@param str_id string
    ["BeginPopupContextItem"] = function(str_id)end,
    ---@return boolean
    ---@param str_id string
    ---@param popup_flags number int
    ["BeginPopupContextItem"] = function(str_id,popup_flags)end,
    ---@return boolean
    ["BeginPopupContextWindow"] = function()end,
    ---@return boolean
    ---@param str_id string
    ["BeginPopupContextWindow"] = function(str_id)end,
    ---@return boolean
    ---@param str_id string
    ---@param popup_flags number int
    ["BeginPopupContextWindow"] = function(str_id,popup_flags)end,
    ---@return boolean
    ["BeginPopupContextVoid"] = function()end,
    ---@return boolean
    ---@param str_id string
    ["BeginPopupContextVoid"] = function(str_id)end,
    ---@return boolean
    ---@param str_id string
    ---@param popup_flags number int
    ["BeginPopupContextVoid"] = function(str_id,popup_flags)end,
    ---@return boolean
    ---@param str_id string
    ["IsPopupOpen"] = function(str_id)end,
    ---@return boolean
    ---@param str_id string
    ---@param popup_flags number int
    ["IsPopupOpen"] = function(str_id,popup_flags)end,
    ["Columns"] = function()end,
    ---@param count number int
    ["Columns"] = function(count)end,
    ---@param count number int
    ---@param id string
    ["Columns"] = function(count,id)end,
    ---@param count number int
    ---@param id string
    ---@param border boolean
    ["Columns"] = function(count,id,border)end,
    ["NextColumn"] = function()end,
    ---@return number int
    ["GetColumnIndex"] = function()end,
    ---@return number
    ["GetColumnWidth"] = function()end,
    ---@return number
    ---@param column_index number int
    ["GetColumnWidth"] = function(column_index)end,
    ---@param column_index number int
    ---@param width number
    ["SetColumnWidth"] = function(column_index,width)end,
    ---@return number
    ["GetColumnOffset"] = function()end,
    ---@return number
    ---@param column_index number int
    ["GetColumnOffset"] = function(column_index)end,
    ---@param column_index number int
    ---@param offset_x number
    ["SetColumnOffset"] = function(column_index,offset_x)end,
    ---@return number int
    ["GetColumnsCount"] = function()end,
    ---@return boolean
    ---@param str_id string
    ["BeginTabBar"] = function(str_id)end,
    ---@return boolean
    ---@param str_id string
    ---@param flags number int
    ["BeginTabBar"] = function(str_id,flags)end,
    ["EndTabBar"] = function()end,
    ---@return boolean
    ---@param label string
    ["BeginTabItem"] = function(label)end,
    ---@return boolean, boolean
    ---@param label string
    ---@param open boolean
    ["BeginTabItem"] = function(label,open)end,
    ---@return boolean, boolean
    ---@param label string
    ---@param open boolean
    ---@param flags number int
    ["BeginTabItem"] = function(label,open,flags)end,
    ["EndTabItem"] = function()end,
    ---@param tab_or_docked_window_label string
    ["SetTabItemClosed"] = function(tab_or_docked_window_label)end,
    ---@param id number uint
    ["DockSpace"] = function(id)end,
    ---@param id number uint
    ---@param sizeX number
    ---@param sizeY number
    ["DockSpace"] = function(id,sizeX,sizeY)end,
    ---@param id number uint
    ---@param sizeX number
    ---@param sizeY number
    ---@param flags number int
    ["DockSpace"] = function(id,sizeX,sizeY,flags)end,
    ---@return number uintDockSpaceOverViewport()
    ---@param dock_id number uint
    ["SetNextWindowDockID"] = function(dock_id)end,
    ---@param dock_id number uint
    ---@param cond number int
    ["SetNextWindowDockID"] = function(dock_id,cond)end,
    ["SetNextWindowClass"] = function()end,
    ---@return number uintGetWindowDockID()
    ---@return boolean
    ["IsWindowDocked"] = function()end,
    ["LogToTTY"] = function()end,
    ---@param auto_open_depth number int
    ["LogToTTY"] = function(auto_open_depth)end,
    ["LogToFile"] = function()end,
    ---@param auto_open_depth number int
    ["LogToFile"] = function(auto_open_depth)end,
    ---@param auto_open_depth number int
    ---@param filename string
    ["LogToFile"] = function(auto_open_depth,filename)end,
    ["LogToClipboard"] = function()end,
    ---@param auto_open_depth number int
    ["LogToClipboard"] = function(auto_open_depth)end,
    ["LogFinish"] = function()end,
    ["LogButtons"] = function()end,
    ---@param fmt string
    ["LogText"] = function(fmt)end,
    ---@param min_x number
    ---@param min_y number
    ---@param max_x number
    ---@param max_y number
    ---@param intersect_current boolean
    ["PushClipRect"] = function(min_x,min_y,max_x,max_y,intersect_current)end,
    ["PopClipRect"] = function()end,
    ["SetItemDefaultFocus"] = function()end,
    ["SetKeyboardFocusHere"] = function()end,
    ---@param offset number int
    ["SetKeyboardFocusHere"] = function(offset)end,
    ---@return boolean
    ["IsItemHovered"] = function()end,
    ---@return boolean
    ---@param flags number int
    ["IsItemHovered"] = function(flags)end,
    ---@return boolean
    ["IsItemActive"] = function()end,
    ---@return boolean
    ["IsItemFocused"] = function()end,
    ---@return boolean
    ["IsItemClicked"] = function()end,
    ---@return boolean
    ---@param mouse_button number int
    ["IsItemClicked"] = function(mouse_button)end,
    ---@return boolean
    ["IsItemVisible"] = function()end,
    ---@return boolean
    ["IsItemEdited"] = function()end,
    ---@return boolean
    ["IsItemActivated"] = function()end,
    ---@return boolean
    ["IsItemDeactivated"] = function()end,
    ---@return boolean
    ["IsItemDeactivatedAfterEdit"] = function()end,
    ---@return boolean
    ["IsItemToggledOpen"] = function()end,
    ---@return boolean
    ["IsAnyItemHovered"] = function()end,
    ---@return boolean
    ["IsAnyItemActive"] = function()end,
    ---@return boolean
    ["IsAnyItemFocused"] = function()end,
    ---@return number, number
    ["GetItemRectMin"] = function()end,
    ---@return number, number
    ["GetItemRectMax"] = function()end,
    ---@return number, number
    ["GetItemRectSize"] = function()end,
    ["SetItemAllowOverlap"] = function()end,
    ---@return boolean
    ---@param sizeX number
    ---@param sizeY number
    ["IsRectVisible"] = function(sizeX,sizeY)end,
    ---@return boolean
    ---@param minX number
    ---@param minY number
    ---@param maxX number
    ---@param maxY number
    ["IsRectVisible"] = function(minX,minY,maxX,maxY)end,
    ---@return number
    ["GetTime"] = function()end,
    ---@return number int
    ["GetFrameCount"] = function()end,
    ---@return string
    ---@param idx number int
    ["GetStyleColorName"] = function(idx)end,
    ---@return boolean
    ---@param id number uint
    ---@param sizeX number
    ---@param sizeY number
    ["BeginChildFrame"] = function(id,sizeX,sizeY)end,
    ---@return boolean
    ---@param id number uint
    ---@param sizeX number
    ---@param sizeY number
    ---@param flags number int
    ["BeginChildFrame"] = function(id,sizeX,sizeY,flags)end,
    ["EndChildFrame"] = function()end,
    ---@return number, number
    ---@param text string
    ["CalcTextSize"] = function(text)end,
    ---@return number, number
    ---@param text string
    ---@param text_end string
    ["CalcTextSize"] = function(text,text_end)end,
    ---@return number, number
    ---@param text string
    ---@param text_end string
    ---@param hide_text_after_double_hash boolean
    ["CalcTextSize"] = function(text,text_end,hide_text_after_double_hash)end,
    ---@return number, number
    ---@param text string
    ---@param text_end string
    ---@param hide_text_after_double_hash boolean
    ---@param wrap_width number
    ["CalcTextSize"] = function(text,text_end,hide_text_after_double_hash,wrap_width)end,
    ---@return number[]
    ---@param value number uint
    ["ColorConvertU32ToFloat4"] = function(value)end,
    ---@return number uintColorConvertFloat4ToU32(table rgba)
    ---@return number, number, number
    ---@param r number
    ---@param g number
    ---@param b number
    ["ColorConvertRGBtoHSV"] = function(r,g,b)end,
    ---@return number, number, number
    ---@param h number
    ---@param s number
    ---@param v number
    ["ColorConvertHSVtoRGB"] = function(h,s,v)end,
    ---@return number int
    ---@param imgui_key number int
    ["GetKeyIndex"] = function(imgui_key)end,
    ---@return boolean
    ---@param user_key_index number int
    ["IsKeyDown"] = function(user_key_index)end,
    ---@return boolean
    ---@param user_key_index number int
    ["IsKeyPressed"] = function(user_key_index)end,
    ---@return boolean
    ---@param user_key_index number int
    ---@param shouldRepeat boolean
    ["IsKeyPressed"] = function(user_key_index,shouldRepeat)end,
    ---@return boolean
    ---@param user_key_index number int
    ["IsKeyReleased"] = function(user_key_index)end,
    ---@return number int
    ---@param key_index number int
    ---@param repeat_delay number
    ---@param rate number
    ["GetKeyPressedAmount"] = function(key_index,repeat_delay,rate)end,
    ["CaptureKeyboardFromApp"] = function()end,
    ---@param want_capture_keyboard_value boolean
    ["CaptureKeyboardFromApp"] = function(want_capture_keyboard_value)end,
    ---@return boolean
    ---@param button number int
    ["IsMouseDown"] = function(button)end,
    ---@return boolean
    ---@param button number int
    ["IsMouseClicked"] = function(button)end,
    ---@return boolean
    ---@param button number int
    ---@param shouldRepeat boolean
    ["IsMouseClicked"] = function(button,shouldRepeat)end,
    ---@return boolean
    ---@param button number int
    ["IsMouseReleased"] = function(button)end,
    ---@return boolean
    ---@param button number int
    ["IsMouseDoubleClicked"] = function(button)end,
    ---@return boolean
    ---@param min_x number
    ---@param min_y number
    ---@param max_x number
    ---@param max_y number
    ["IsMouseHoveringRect"] = function(min_x,min_y,max_x,max_y)end,
    ---@return boolean
    ---@param min_x number
    ---@param min_y number
    ---@param max_x number
    ---@param max_y number
    ---@param clip boolean
    ["IsMouseHoveringRect"] = function(min_x,min_y,max_x,max_y,clip)end,
    ---@return boolean
    ["IsMousePosValid"] = function()end,
    ---@return boolean
    ["IsAnyMouseDown"] = function()end,
    ---@return number, number
    ["GetMousePos"] = function()end,
    ---@return number, number
    ["GetMousePosOnOpeningCurrentPopup"] = function()end,
    ---@return boolean
    ---@param button number int
    ["IsMouseDragging"] = function(button)end,
    ---@return boolean
    ---@param button number int
    ---@param lock_threshold number
    ["IsMouseDragging"] = function(button,lock_threshold)end,
    ---@return number, number
    ["GetMouseDragDelta"] = function()end,
    ---@return number, number
    ---@param button number int
    ["GetMouseDragDelta"] = function(button)end,
    ---@return number, number
    ---@param button number int
    ---@param lock_threshold number
    ["GetMouseDragDelta"] = function(button,lock_threshold)end,
    ["ResetMouseDragDelta"] = function()end,
    ---@param button number int
    ["ResetMouseDragDelta"] = function(button)end,
    ---@return number int
    ["GetMouseCursor"] = function()end,
    ---@param cursor_type number int
    ["SetMouseCursor"] = function(cursor_type)end,
    ["CaptureMouseFromApp"] = function()end,
    ---@param want_capture_mouse_value boolean
    ["CaptureMouseFromApp"] = function(want_capture_mouse_value)end,
    ---@return string
    ["GetClipboardText"] = function()end,
    ---@param text string
    ["SetClipboardText"] = function(text)end,
    ---@param lua state_view
    ["InitEnums"] = function(lua)end,
    ---@param lua state_view
    ["Init"] = function(lua)end,
};
ImGuiCol = {
    ["Text"]=1,
    ["TextDisabled"]=2,
    ["WindowBg"]=3,
    ["ChildWindowBg"]=4,
    ["PopupBg"]=5,
    ["Border"]=6,
    ["BorderShadow"]=7,
    ["FrameBg"]=8,
    ["FrameBgHovered"]=9,
    ["FrameBgActive"]=10,
    ["TitleBg"]=11,
    ["TitleBgActive"]=12,
    ["TitleBgCollapsed"]=13,
    ["MenuBarBg"]=14,
    ["ScrollbarBg"]=15,
    ["ScrollbarGrab"]=16,
    ["ScrollbarGrabHovered"]=17,
    ["ScrollbarGrabActive"]=18,
    ["ComboBg"]=19,
    ["CheckMark"]=20,
    ["SliderGrab"]=21,
    ["SliderGrabActive"]=22,
    ["Button"]=23,
    ["ButtonHovered"]=24,
    ["ButtonActive"]=25,
    ["Header"]=26,
    ["HeaderHovered"]=27,
    ["HeaderActive"]=28,
    ["Separator"]=29,
    ["SeparatorHovered"]=30,
    ["SeparatorActive"]=31,
    ["ResizeGrip"]=32,
    ["ResizeGripHovered"]=33,
    ["ResizeGripActive"]=34,
    ["CloseButton"]=35,
    ["CloseButtonHovered"]=36,
    ["CloseButtonActive"]=37,
    ["PlotLines"]=38,
    ["PlotLinesHovered"]=39,
    ["PlotHistogram"]=40,
    ["PlotHistogramHovered"]=41,
    ["TextSelectedBg"]=42,
    ["ModalWindowDarkening"]=43
}