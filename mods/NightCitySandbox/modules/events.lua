local Events = {}

local function weightedChoice(weightMap)
  local total = 0
  for _, weight in pairs(weightMap) do
    total = total + weight
  end

  if total <= 0 then return nil end

  local roll = math.random() * total
  local cumulative = 0
  for key, weight in pairs(weightMap) do
    cumulative = cumulative + weight
    if roll <= cumulative then
      return key
    end
  end

  return nil
end

local function districtWithMaxHeat(districtHeat)
  local maxDistrict = "city_center"
  local maxValue = -1

  for district, value in pairs(districtHeat) do
    if value > maxValue then
      maxDistrict = district
      maxValue = value
    end
  end

  return maxDistrict, maxValue
end

function Events.new(state, config, log)
  local self = {
    state = state,
    config = config,
    log = log or function(_) end
  }

  function self:onPlayerCrime(district, severity)
    local heatGain = 5 * math.max(1, severity or 1)
    self.state:addHeat(district or "unknown", heatGain)
    self.state:adjustFaction("ncpd", -2 * (severity or 1))
    self.state:adjustFaction("citizens", -1 * (severity or 1))
    self.state:recordConsequence("crime", { district = district, severity = severity })
  end

  function self:onGangContract(success)
    if success then
      self.state:adjustFaction("gangs", 4)
      self.state:adjustFaction("corps", -2)
      self.state:recordConsequence("gang_contract_success", {})
    else
      self.state:adjustFaction("gangs", -5)
      self.state:recordConsequence("gang_contract_fail", {})
    end
  end

  function self:worldPulse()
    self.state:decayHeat()

    local eventKey = weightedChoice(self.config.ConsequenceWeights)
    if not eventKey then return nil end

    local district, hottest = districtWithMaxHeat(self.state.districtHeat)
    local tier = self.state:getEscalationTier()

    local payload = {
      district = district,
      hottestHeat = hottest,
      escalation = tier and tier.label or "Calm"
    }

    if eventKey == "ambush" and (hottest or 0) > 35 then
      self.state:recordConsequence("ambush_spawned", payload)
      self.log("[NCS] Consequence: hostile ambush forming in " .. district)
    elseif eventKey == "checkpoint" and (hottest or 0) > 20 then
      self.state:recordConsequence("ncpd_checkpoint", payload)
      self.log("[NCS] Consequence: NCPD checkpoint deployed in " .. district)
    elseif eventKey == "vendorDiscount" and self.state.factions.citizens > 25 then
      self.state:recordConsequence("street_discount", payload)
      self.log("[NCS] Consequence: local vendors trust you in " .. district)
    elseif eventKey == "citizenPanic" and self.state.factions.citizens < -25 then
      self.state:recordConsequence("citizen_panic", payload)
      self.log("[NCS] Consequence: civilians panic and report sightings")
    elseif eventKey == "fixerOpportunity" and self.state.totalChaos > 120 then
      self.state:recordConsequence("fixer_special_gig", payload)
      self.log("[NCS] Consequence: fixer unlocks high-risk gig")
    end

    return eventKey
  end

  return self
end

return Events
