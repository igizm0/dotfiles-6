--------------------------------------------------------------------------------
-- _require
--------------------------------------------------------------------------------
require("hs.ipc") -- for hammerspoon cli TODO: see if I use it


--------------------------------------------------------------------------------
-- _constants
--------------------------------------------------------------------------------
local caps = {"alt", "ctrl"}
local cmd_alt = {"cmd", "alt"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"}
local cmd_alt_shift = {"cmd", "alt", "shift"}
local cmd_alt_ctrl_shift = {"cmd", "alt", "ctrl", "shift"}

local main_monitor = "Color LCD"
local second_monitor = "DELL U2515H"

local mouseCircle = nil
local mouseCircleTimer = nil



--------------------------------------------------------------------------------
-- _functions
--------------------------------------------------------------------------------
function mouseHighlight()
    -- delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- prepare a circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=100,["blue"]=0,["green"]=40,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- set a timer to delete the circle after 2 seconds
    mouseCircleTimer = hs.timer.doAfter(2, function() mouseCircle:delete() end)
end

--------------------------------------------------------------------------------
-- _utils
--------------------------------------------------------------------------------
-- show my todo task in a neat window briefly
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "I", function()
hs.alert.show( ( hs.execute("~/Documents/d.\\ app/bitbar/todo") ) )
end)

-- visually circle my mouse pointer
hs.hotkey.bind({"cmd", "shift"}, "F12", mouseHighlight) 

-- _wifi watcher
wifiwatcher = hs.wifi.watcher.new(function ()
    net = hs.wifi.currentNetwork()
    if net==nil then
        hs.notify.show("wifi disconnected","","","")
    else
        hs.notify.show("wifi connected","",net,"")
    end
end)
wifiwatcher:start()

local anycomplete = require "anycomplete/anycomplete"
anycomplete.registerDefaultBindings(cmd_alt_ctrl, "W")

--------------------------------------------------------------------------------
-- _window management
--------------------------------------------------------------------------------
hs.window.animationDuration = 0 

--------------------------------------------------------------------------------
-- _testing
--------------------------------------------------------------------------------
hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("hey there alert")
end)





--------------------------------------------------------------------------------
-- _meta 
--------------------------------------------------------------------------------
hs.hotkey.bind(cmd_alt_shift, "M", hs.toggleConsole)


-- needed for cli utility I use to reload config
require("hs.ipc")

-- reload config from hotkey
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "U", function()
  hs.reload()
end)

-- called on every config reload to notify if it was reloaded
hs.alert.show("config loaded")


