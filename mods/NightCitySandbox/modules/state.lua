local State = {}

local function clamp(value, min, max)
  if value < min then return min end
  if value > max then return max end
  return value
end

function State.new(config)
  local self = {
    config = config,
    districtHeat = {},
    factions = {},
    consequences = {},
    lastTick = 0,
    totalChaos = 0
  }

  for name, _ in pairs(config.Factions) do
    self.factions[name] = 0
  end

  function self:addHeat(district, amount)
    local current = self.districtHeat[district] or 0
    local nextValue = clamp(current + amount, 0, self.config.MaxHeat)
    self.districtHeat[district] = nextValue
    self.totalChaos = self.totalChaos + math.max(0, amount)
  end

  function self:decayHeat()
    for district, value in pairs(self.districtHeat) do
      self.districtHeat[district] = clamp(value - self.config.HeatDecayPerTick, 0, self.config.MaxHeat)
    end
  end

  function self:adjustFaction(name, delta)
    local rules = self.config.Factions[name]
    if not rules then return end
    local value = self.factions[name] or 0
    self.factions[name] = clamp(value + delta, rules.min, rules.max)
  end

  function self:recordConsequence(tag, payload)
    table.insert(self.consequences, {
      tag = tag,
      payload = payload or {},
      timestamp = os.time()
    })

    if #self.consequences > 50 then
      table.remove(self.consequences, 1)
    end
  end

  function self:getAverageHeat()
    local total = 0
    local count = 0
    for _, value in pairs(self.districtHeat) do
      total = total + value
      count = count + 1
    end

    if count == 0 then return 0 end
    return total / count
  end

  function self:getEscalationTier()
    local avgHeat = self:getAverageHeat()
    local tier = nil

    for _, entry in ipairs(self.config.HeatEscalation) do
      if avgHeat >= entry.threshold then
        tier = entry
      end
    end

    return tier
  end

  return self
end

return State
