--╔══════════════════════════════════════════════════════════════════════════╗--
--║                                                                          ║--
--║  ██  ██  ██████  ██████   █████    ██    ██████   ████    ████    ████   ║--
--║  ██ ██     ██      ██    ██       ████     ██    ██  ██  ██          ██  ║--
--║  ████      ██      ██    ██       █  █     ██     █████  █████    ████   ║--
--║  ██ ██     ██      ██    ██      ██████    ██        ██  ██  ██  ██      ║--
--║  ██  ██  ██████    ██     █████  ██  ██    ██     ████    ████    ████   ║--
--║                                                                          ║--
--╚══════════════════════════════════════════════════════════════════════════╝--

--v2.2

---@alias KattArmor.ArmorPartID KattItemChange.ArmorSlotID

---@alias KattArmor.ArmorMaterialID
---| "leather"
---| "chainmail"
---| "iron"
---| "golden"
---| "diamond"
---| "netherite"
---| "turtle"
---| string

local ItemChange = require((...):gsub("(.)$", "%1.") .. "KattItemChangeEvent") --[[@as KattItemChange.API]]

---@type table<KattArmor.ArmorPartID,ModelPart[]>
local armorParts = {
  HELMET = {},
  CHESTPLATE = {},
  LEGGINGS = {},
  BOOTS = {},
}
---@type table<KattArmor.ArmorPartID,{forceRender:KattArmor.ArmorMaterialID?,prevMaterial:KattArmor.ArmorMaterialID?}>
local armorProperties = {
  HELMET = {},
  CHESTPLATE = {},
  LEGGINGS = {},
  BOOTS = {},
}

---@param armorID KattArmor.ArmorPartID
---@param ... ModelPart
local function addArmorPart(armorID, ...)
  if not armorParts[armorID] then error(("Expected valid ArmorPartID, recieved \"%s\""):format(armorID), 3) end
  local vararg = table.pack(...)
  for _, modelPart in ipairs(vararg) do
    if type(modelPart) ~= "ModelPart" then error(("Expected ModelPart, got %s"):format(type(modelPart)), 3) end
    table.insert(armorParts[armorID], modelPart)
  end
end

---@alias KattArmor.Events.EventArgs {visible:boolean,glint:boolean,color:Vector3,texture:string|Texture,texture_e:string|Texture|nil}
local EventAPI = require((...):gsub("(.)$", "%1.") .. "KattEventsAPI")

---@class KattArmor.API
local KattArmorAPI = EventAPI.eventifyTable({})

---@class KattArmor.Events.Change:KattEvent
---@field register fun(self:KattArmor.Events.Change,func:KattArmor.Events.Subscriptions.Change,name?:string)
---@alias KattArmor.Events.Subscriptions.Change fun(arg:KattArmor.Events.EventArgs,armorID:KattArmor.ArmorPartID,material:KattArmor.ArmorMaterialID?,item:ItemStack,prevMaterial:KattArmor.ArmorMaterialID?,prevItem:ItemStack)
---A KattEvent that gets invoked when the armor changes, but before anything happens.
---You can change how the armor should be rendered using this event.
KattArmorAPI.onChange = EventAPI.newEvent() --[[@as KattArmor.Events.Change]]

---@class KattArmor.Events.Render:KattEvent
---@field register fun(self:KattArmor.Events.Render,func:KattArmor.Events.Subscriptions.Render,name?:string)
---@alias KattArmor.Events.Subscriptions.Render fun(arg:KattArmor.Events.EventArgs,armorID:KattArmor.ArmorPartID,material:KattArmor.ArmorMaterialID?,item:ItemStack,prevMaterial:KattArmor.ArmorMaterialID?,prevItem:ItemStack)
---A KattEvent that gets invoked when the armor changes, after all changes have been solidified.
---The values here cannot be changed, so subscriptions can get valid values from this event.
KattArmorAPI.onRender = EventAPI.newEvent() --[[@as KattArmor.Events.Render]]

---@param armorID KattArmor.ArmorPartID
---@param ... ModelPart
function KattArmorAPI.addArmor(armorID, ...) addArmorPart(armorID, ...) end

---@param ... ModelPart
function KattArmorAPI.addHelmet(...) addArmorPart(ItemChange.ItemSlotIDs[6], ...) end

---@param ... ModelPart
function KattArmorAPI.addChestplate(...) addArmorPart(ItemChange.ItemSlotIDs[5], ...) end

---@param ... ModelPart
function KattArmorAPI.addLeggings(...) addArmorPart(ItemChange.ItemSlotIDs[4], ...) end

---@param ... ModelPart
function KattArmorAPI.addBoots(...) addArmorPart(ItemChange.ItemSlotIDs[3], ...) end

function split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

---@param armorID KattArmor.ArmorPartID
---@param materialID KattArmor.ArmorMaterialID
function KattArmorAPI.renderMaterial(armorID, materialID)
  if not armorParts[armorID] then error(("Expected valid ArmorPartID, recieved \"%s\""):format(armorID), 2) end
  armorProperties[armorID].forceRender = materialID
  ItemChange.forceUpdate(ItemChange.ItemSlots[armorID])
end

ItemChange.onItemChange:register(function(itemSlot, item, prevItem)
  if itemSlot <= 2 then return end
  local armorID = ItemChange.ItemSlotIDs[itemSlot] --[[@as KattArmor.ArmorPartID]]
  local armorMaterial = armorProperties[armorID].forceRender or string.match(item.id, ("^.*:(.*)_%s"):format(armorID:lower()))
  local isArmor = armorMaterial and true or false
  local visible = isArmor
  local glint = item:hasGlint()
  local color = 0xFFFFFF
  if armorMaterial == "leather" then
    color = item.tag and item.tag.display and item.tag.display.color or 0xA06540
  end
  color = vectors.intToRGB(color)
  local pathMaterial = armorMaterial
  if armorMaterial == "golden" then pathMaterial = "gold" end
  local layer = itemSlot == 4 and "2" or "1"
  local pref = split(item.id,':')[1]
  local path = pathMaterial and ("%s:textures/models/armor/%s_layer_%s.png"):format(pref,pathMaterial, layer)
  if (pref=='paradise_lost') then 
	local mm = "minecraft:textures/models/armor/paradise_lost_%s_layer_%s.png"
	path = mm:format(pathMaterial, layer) 
  end
  ---@type KattArmor.Events.EventArgs
  local eventArg = {
    visible = visible,
    glint = glint,
    color = color,
    texture = path,
  }

  KattArmorAPI.onChange(eventArg, armorID, armorMaterial, item, armorProperties[armorID].prevMaterial, prevItem)

  local eVisible, eColor, eTexture, eTexture_e =
      eventArg.visible and nil, eventArg.color, eventArg.texture, eventArg.texture_e
  local primaryTextureType = not eTexture and "PRIMARY"
      or type(eTexture) == "string" and "RESOURCE"
      or "CUSTOM"
  local secondaryTextureType = not eTexture_e and "SECONDARY"
      or type(eTexture_e) == "string" and "RESOURCE"
      or "CUSTOM"
  local secondaryRenderType = eventArg.glint and "GLINT"
      or eventArg.texture_e and "EMISSIVE"
      or "NONE"
  if Armor == false then
	  eVisible = false
  end
  for _, modelPart in ipairs(armorParts[armorID]) do
    modelPart:setVisible(eVisible)
    modelPart:setColor(eColor)
    modelPart:setPrimaryTexture(primaryTextureType, eTexture)
    modelPart:setSecondaryTexture(secondaryTextureType, eTexture_e)
    modelPart:setSecondaryRenderType(secondaryRenderType)
  end

  KattArmorAPI.onRender(eventArg, armorID, armorMaterial, item, armorProperties[armorID].prevMaterial, prevItem)

  armorProperties[armorID].prevMaterial = armorMaterial
end)

return KattArmorAPI
