local Config = require("mods/NightCitySandbox/config")
local State = require("mods/NightCitySandbox/modules/state")
local Events = require("mods/NightCitySandbox/modules/events")
local UI = require("mods/NightCitySandbox/modules/ui")

local state = State.new(Config)
local events = Events.new(state, Config, print)
local ui = UI.new(state)

NCS = NCS or {}

function NCS.DebugState()
  return ui:debugState()
end

function NCS.AddHeat(district, amount)
  state:addHeat(district or "city_center", amount or 5)
  print("[NCS] Heat adjusted in " .. tostring(district) .. " by " .. tostring(amount))
end

function NCS.AdjustFaction(name, delta)
  state:adjustFaction(name, delta)
  print("[NCS] Faction " .. tostring(name) .. " adjusted by " .. tostring(delta))
end

registerForEvent("onInit", function()
  print("[NCS] Night City Sandbox initialized")
end)

registerForEvent("onUpdate", function(delta)
  state.lastTick = state.lastTick + delta
  if state.lastTick >= Config.TickSeconds then
    state.lastTick = 0
    events:worldPulse()
  end
end)

-- Example action hooks for testing from CET console.
function NCS.MockCrime(district, severity)
  events:onPlayerCrime(district or "watson", severity or 1)
end

function NCS.MockGangContract(success)
  events:onGangContract(success == true)
end
