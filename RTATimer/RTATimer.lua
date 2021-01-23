ModUtil.RegisterMod("RTATimer")

local config = {
  ModName = "Timer",
  UseRealTime = false
}

if ModConfigMenu then
  ModConfigMenu.Register(config)
end

ModUtil.WrapBaseFunction("AddTimerBlock", function(baseFunc, ...)
  if config.UseRealTime then return end
  return baseFunc(...)
end, RTATimer)

