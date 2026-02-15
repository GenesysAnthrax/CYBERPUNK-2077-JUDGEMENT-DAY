local UI = {}

function UI.new(state)
  local self = { state = state }

  local function summarizeHeat(heat)
    local out = {}
    for district, value in pairs(heat) do
      table.insert(out, district .. ":" .. string.format("%.1f", value))
    end
    table.sort(out)
    return table.concat(out, ", ")
  end

  function self:debugState()
    local tier = self.state:getEscalationTier()
    local summary = {
      avgHeat = string.format("%.2f", self.state:getAverageHeat()),
      escalation = tier and tier.label or "Calm",
      heat = summarizeHeat(self.state.districtHeat),
      ncpd = self.state.factions.ncpd,
      gangs = self.state.factions.gangs,
      corps = self.state.factions.corps,
      citizens = self.state.factions.citizens,
      consequences = #self.state.consequences
    }

    print("[NCS] DebugState")
    for k, v in pairs(summary) do
      print("  - " .. k .. ": " .. tostring(v))
    end

    return summary
  end

  return self
end

return UI
