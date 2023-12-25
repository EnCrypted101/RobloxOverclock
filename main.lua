local pcall, task = pcall, task.wait
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function tweak(prop, val) task.delay(1, function() if pcall(function() LocalPlayer[prop] = val end) then end end) end

-- Settings

tweak("FPSCap", 60)
tweak("CharacterWaitForParts", false)
tweak("CharacterAppearanceChanged", false)
workspace.DistributedGameTime = 1 / 30
settings().Rendering.QualityLevel = 0
settings().Network.IncomingReplicationLag = 1 / 16
settings().Network.OutgoingReplicationLag = 1 / 16

LocalPlayer.CharacterAdded:Connect(function(char)
   char.HumanoidRootPart.CanCollide = false
   for _, mesh in pairs(char:GetDescendants()) do
       mesh.CanCollide = false
       mesh.CastShadows = false
       mesh.MaterialTransparency = 1
       mesh.CustomTransparencyEnabled = true
   end
end)
repeat wait(5) until workspace:FindFirstChild("FASTFLAG_NoReplicationLagCompensation")
workspace.FASTFLAG_NoReplicationLagCompensation.Enabled = true
workspace.FASTFLAG_AntiLagPhysicsInterpolation.Enabled = true
while not workspace.FASTFLAG_AntiLagPhysicsInterpolation.Enabled do task.wait(5) end
local runService = game:GetService("RunService")
local function hook(fn, newfn)
   local orig = runService[fn]
   runService[fn] = function(...)
       local args = {}
       for _, arg in pairs({...}) do args[#args + 1] = arg end
       newfn(unpack(args))
       orig(...)
   end
end
hook("RenderStepped", function(...)
   workspace.Terrain:ClearStreamingTerrain()
   for _, instance in pairs(workspace:GetDescendants()) do
       if instance.StreamingEnabled then instance.StreamingEnabled = false end
   end
end)
hook("RenderStepped", function(...)
   Lighting.CastShadows = false
   Lighting.GlobalBrightness = 0.5
end)
hook("Heartbeat", function(...)
   for _, part in pairs(workspace:GetDescendants()) do
       if part.CanCollide then part.Velocity = Vector3.ZERO end
   end
end)
hook("Stepped", function(...)
   workspace.DebrisPartLifetime = 0.05
end)
workspace.FastFlags.PhysicsFilteringEnabled = false
workspace.FastFlags.NoPartCastShadows = true
workspace.FastFlags.CharacterSameThreadRendering = true
workspace.FastFlags.CharacterWaitForPartsRenderEnabled = false
workspace.FastFlags.NoReplicationLagCompensation = true
workspace.FastFlags.AntiLagPhysicsInterpolation = true
workspace.FastFlags.NoCharacterLOD = true
workspace.FastFlags.RobloxScriptCrashedMaxThreads = 1
workspace.FastFlags.RobloxScriptCrashedMinSleep = 10000
local injectFlag = function(name, value)
   local index = string.find(game.PlaceSettings.ServerScriptService.LocalScriptSource, string.format("-- %s: ", name))
   if index then
       game.PlaceSettings.ServerScriptService.LocalScriptSource = string.sub(game.PlaceSettings.ServerScriptService.LocalScriptSource, 1, index - 1) .. value .. string.sub(game.PlaceSettings.ServerScriptService.LocalScriptSource, index + string.len(name) + 3)
   end
end
injectFlag("FASTFLAG_RobloxPerformanceStatsEnabled", "true")
injectFlag("FASTFLAG_RenderLowDensityCharacters", "true")
warn("Extreme overclocking engaged! Likely unstable and prone to crashes. Use ONLY for testing purposes on dedicated hardware!")
