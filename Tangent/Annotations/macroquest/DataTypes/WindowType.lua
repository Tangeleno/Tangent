---@diagnostic disable: duplicate-index, missing-return
---@class WindowType
__WindowType = {
    ---@return ARGBType
    ---Background color
    BGColor = function()end,
    ---@return boolean
    ---Returns TRUE if the button has been checked
    Checked = function()end,
    ---@return WindowType
    ---Child with this name
    ---@param name string
    Child = function(name)end,
    ---@return boolean
    ---Returns TRUE if the window has children
    Children = function()end,
    ---Does the ction of closing a window
    DoClose = function()end,
    ---Does the action of opening a window
    DoOpen = function()end,
    ---@return boolean
    ---Returns TRUE if the window is enabled
    Enabled = function()end,
    ---@return WindowType
    ---First child window
    FirstChild = function()end,
    ---@return number
    ---Height in pixels
    Height = function()end,
    ---@return boolean
    ---Returns TRUE if the window is highlighted
    Highlighted = function()end,
    ---@return boolean
    ---Has the other person clicked the Trade button?
    HisTradeReady = function()end,
    ---@return number
    ---Horizontal scrollbar range
    HScrollMax = function()end,
    ---@return number
    ---Horizontal scrollbar position
    HScrollPos = function()end,
    ---@return number
    ---Horizontal scrollbar position in % to range from 0 to 100
    HScrollPct = function()end,
    ---@return number
    ---Number of items in a Listbox or Combobox
    Items = function()end,
    ---Does the action of clicking the left mouse button down
    LeftMouseDown = function()end,
    ---Does the action of holding the left mouse button
    LeftMouseHeld = function()end,
    ---does the action of holding the left mouse button up
    LeftMouseHeldUp = function()end,
    ---Does the action of clicking the left mouse button up
    LeftMouseUp = function()end,
    ---@return string|number
    ---Get the text for the #th item in a list box. Only works on list boxes. Use of ,y is optional and allows selection of the column of the window to get text from.
    ---@param row number
    ---@param column? number
    List = function(row,column)end,
    ---@return number
    ---Find an item in a list box by partial match (use window.List[=text] for exact). Only works on list boxes. Use of ,y is optional and allows selection of the column of the window to search in.
    ---@param text string
    ---@param column? number
    List = function(text,column)end,
    ---@return boolean
    ---Returns TRUE if the window is minimized
    Minimized = function()end,
    ---@return boolean
    ---Returns TRUE if the mouse is currently over the window
    MouseOver = function()end,
    ---@return boolean
    ---Have I clicked the Trade button?
    MyTradeReady = function()end,
    ---@return string
    ---Name of window piece, e.g. "ChatWindow" for top level windows, or the piece name for child windows. Note: this is Custom UI dependent
    Name = function()end,
    ---@return WindowType
    ---Next sibling window
    Next = function()end,
    ---@return boolean
    ---Returns TRUE if the window is open
    Open = function()end,
    ---@return WindowType
    ---Parent window
    Parent = function()end,
    ---does the action of clicking the right mouse button
    RightMouseDown = function()end,
    ---Does the action of holding the right mouse button
    RightMouseHeld = function()end,
    ---Does the action of holding the right mouse button up
    RightMouseHeldUp = function()end,
    ---Does the action of clicking the right mouse button up
    RightMouseUp = function()end,
    ---Selects the specified window
    Select = function()end,
    ---Selects the specified window
    ---@param index integer
    Select = function(index)end,
    ---@return string
    ---ScreenID of window piece. Note: This is not Custom UI dependent, it must be the same on all UIs
    ScreenID = function()end,
    ---@return boolean
    ---Returns TRUE if the window has siblings
    Siblings = function()end,
    ---@return number
    ---Window style code
    Style = function()end,
    ---@return string
    ---Window's text
    Text = function()end,
    ---@return string
    ---TooltipReference text
    Tooltip = function()end,
    ---@return string
    ---Type of window piece (Screen for top level windows, or Listbox, Button, Gauge, Label, Editbox, Slider, etc)
    Type = function()end,
    ---@return number
    ---Vertical scrollbar range
    VScrollMax = function()end,
    ---@return number
    ---Vertical scrollbar position in % to range from 0 to 100
    VScrollPct = function()end,
    ---@return number
    ---Vertical scrollbar position
    VScrollPos = function()end,
    ---@return number
    ---Width in pixels
    Width = function()end,
    ---@return number
    ---Screen X position
    X = function()end,
    ---@return number
    ---Screen Y position
    Y = function()end,
    ---@return number
    Value = function()end,
    ---@return integer
    ---Index of the currently selected/highlighted item in a list or treeview
    GetCurSel = function()end
}