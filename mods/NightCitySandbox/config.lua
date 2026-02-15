local Config = {}

Config.Debug = true
Config.TickSeconds = 15.0
Config.MaxHeat = 100
Config.HeatDecayPerTick = 2

Config.Factions = {
  ncpd = { min = -100, max = 100 },
  gangs = { min = -100, max = 100 },
  corps = { min = -100, max = 100 },
  citizens = { min = -100, max = 100 }
}

Config.HeatEscalation = {
  { threshold = 20, label = "Patrol Attention", policeMultiplier = 1.1 },
  { threshold = 40, label = "Active Search", policeMultiplier = 1.35 },
  { threshold = 60, label = "District Lockdown", policeMultiplier = 1.7 },
  { threshold = 80, label = "MAX-TAC Risk", policeMultiplier = 2.2 }
}

Config.ConsequenceWeights = {
  ambush = 0.25,
  checkpoint = 0.2,
  vendorDiscount = 0.15,
  citizenPanic = 0.2,
  fixerOpportunity = 0.2
}

return Config
