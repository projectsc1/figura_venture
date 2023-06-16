--╔══════════════════════════════════════════════════════════════════════════╗--
--║                                                                          ║--
--║  ██  ██  ██████  ██████   █████    ██    ██████   ████    ████    ████   ║--
--║  ██ ██     ██      ██    ██       ████     ██    ██  ██  ██          ██  ║--
--║  ████      ██      ██    ██       █  █     ██     █████  █████    ████   ║--
--║  ██ ██     ██      ██    ██      ██████    ██        ██  ██  ██  ██      ║--
--║  ██  ██  ██████    ██     █████  ██  ██    ██     ████    ████    ████   ║--
--║                                                                          ║--
--╚══════════════════════════════════════════════════════════════════════════╝--

--v1.0

---@alias KattDynamicCrosshair.Target EntityAPI.any|BlockState|nil

local EventAPI = require(((...):match("^(.*%.).+$") or "") .. "scripts.armor.KattEventsAPI",
  function() return false end) --[[@as KattEvent.API]]
---@alias KattDynamicCrosshair.Subscriptions.Tick fun(mutableArgs:{pos:Vector3,target:KattDynamicCrosshair.Target},side:EntityAPI.blockSide)
---@class KattDynamicCrosshair.Events.Tick:KattEvent
---@field register fun(self:KattDynamicCrosshair.Events.Tick,func:KattDynamicCrosshair.Subscriptions.Tick,name:string?)
local onTick = EventAPI and EventAPI.newEvent()

---@alias KattDynamicCrosshair.Subscriptions.Render fun(mutableArgs:{visible:boolean,scale:number,screenPos:Vector2},model:ModelPart?,worldPos:Vector3,target:KattDynamicCrosshair.Target,blockSide:EntityAPI.blockSide)
---@class KattDynamicCrosshair.Events.Render:KattEvent
---@field register fun(self:KattDynamicCrosshair.Events.Render,func:KattDynamicCrosshair.Subscriptions.Render,name:string?)
local onRender = EventAPI and EventAPI.newEvent()

local pos, _pos = vectors.vec3(), vectors.vec3()
---@type KattDynamicCrosshair.Target
local target, side
function events.TICK()
  _pos:set(pos)
  local entity, entityPos = player:getTargetedEntity(5)
  local block, blockPos, blockSide = player:getTargetedBlock(true, 5)
  if entity then
    pos:set(entityPos)
    target = entity
    side = nil
  elseif block then
    pos:set(blockPos)
    target = block
    if target.id == "minecraft:air"
      or target.id == "minecraft:cave_air"
      or target.id == "minecraft:void_air" then
      target = nil
    end
    side = blockSide
  else
    pos:set(player:getPos()):add(0, player:getEyeHeight()):add(player:getLookDir() * 5)
    target = nil
    side = nil
  end

  local eventArgs = {
    pos = pos:copy(),
    target = target,
  }
  if onTick then onTick(eventArgs, side) end
  pos:set(eventArgs.pos)
  target = eventArgs.target
end

local model = models.Crosshair
if model then model:setParentType("GUI") end
function events.RENDER(delta, ctx)
  if ctx ~= "FIRST_PERSON" and ctx ~= "RENDER" then return end
  local deltaPos = math.lerp(_pos, pos, delta)
  local screenSpace = vectors.worldToScreenSpace(deltaPos)
  local coords = screenSpace.xy:add(1, 1):mul(client.getScaledWindowSize()):div(-2, -2)
  local scale = 3 / screenSpace.w
  local visible = screenSpace.z >= 1

  local eventArgs = {
    visible = visible,
    scale = scale,
    screenPos = coords:copy(),
  }

  if onRender then onRender(eventArgs, model, deltaPos, target, side) end

  if not model then return end
  model:setVisible(eventArgs.visible)
  model:setPos(eventArgs.screenPos.xy_)
  model:setScale(eventArgs.scale, eventArgs.scale, eventArgs.scale)
end

local API = {}
if EventAPI then
  API = EventAPI.eventifyTable(API)
else
  API = setmetatable(API, {
    __newindex = function(t, i, v)
      local eventName = string.upper(i)
      if eventName == "ONTICK" or eventName == "ONRENDER" then
        error("KattEventsAPI.lua is required to be in the same folder as KattDynamicCrosshair.lua to use Events."
          , 2)
      end
      rawset(t, i, v)
    end,
    __index = function(t, i)
      local eventName = string.upper(i)
      if eventName == "ONTICK" or eventName == "ONRENDER" then
        error("KattEventsAPI.lua is required to be in the same folder as KattDynamicCrosshair.lua to use Events."
          , 2)
      end
      return rawget(t, i)
    end,
  })
end

API.onTick = onTick
API.onRender = onRender

---Sets the ModelPart to use for the crosshair
---@param modelPart ModelPart?
function API.setModel(modelPart)
  if type(modelPart) ~= "ModelPart" and modelPart ~= nil then error(
      ("Invalid type for parameter `modelPart`. Expected a <ModelPart>, recieved <%s> %s")
      :format(type(modelPart), tostring(modelPart)), 2)
  end
  model = modelPart
  if model then model:setParentType("GUI") end
end

return API
