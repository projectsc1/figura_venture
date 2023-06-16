local ArmorAPI=require("scripts.armor.KattArmorAPI")

function getDescendants(obj)
	local nt = {}
	local v = nil
	if obj.getChildren then
		v = obj:getChildren()
	end
	if v and #v > 0then
		for x,d in pairs(v) do
			for i,o in pairs(getDescendants(d)) do
				table.insert(nt,o)
			end
		end
	else
		return {obj}
	end
	return nt
end

function timeout(time, func) 
	local t = client.getSystemTime() + time; 
	events.RENDER:register(function() 
		if client.getSystemTime() >= t then 
			func(); 
			events.RENDER:remove("timeout") 
		end 
	end, "timeout") 
end

root = models.model.root
ArmorAPI.addHelmet(root.Head.Helmet) -- select helmet parts
ArmorAPI.addChestplate( -- select chestplate parts
  root.Body.Chestplate,
  root.RightArm.RightArmArmor,
  root.LeftArm.LeftArmArmor
)
ArmorAPI.addLeggings( -- select leggigns parts
  root.Body.Belt,
  root.RightLeg.RightLegArmor,
  root.LeftLeg.LeftLegArmor
)
ArmorAPI.addBoots( -- select boots parts
  root.RightLeg.RightBoot,
  root.LeftLeg.LeftBoot
)

nameplate.ENTITY:setPos(0,-0.8,0)
renderer:offsetCameraPivot(vec(0,-0.8,0))

root.Head.eyeglow:setLight(15)

ArmorAPI.onChange:register(function(b,c,d)
	if c == 'HELMET' and b.visible == true then
		root.Head.spine1:setVisible(false)
	elseif c == 'HELMET' and b.visible == false then
		root.Head.spine1:setVisible(true)
	end
end)

renderer:setRenderCrosshair(false)

events.render:register(function(t,ctx)
	renderer:offsetCameraPivot(vec(0,-0.8,0))
	if (player:getPose()=='CROUCHING') then
		root.RightLeg:setPos(vec(0,-2.5,-3))
		root.LeftLeg:setPos(vec(0,-2.5,-3))
		root:setPos(vec(0,2,0))
	elseif player:getVehicle() then
		renderer:offsetCameraPivot()
		root:setPos(vec(0,6,0))
	else
		root.RightLeg:setPos(vec(0,0,0))
		root.LeftLeg:setPos(vec(0,0,0))
		root:setPos(vec(0,0,0))
	end
	
	local vel = player:getVelocity()
	
	if #(animations:getPlaying()) > 0 then
		if vel:length() > 0.05 then
			animations:stopAll()
		end
	end
	
	if ctx == "FIRST_PERSON" then
		root.RightArm:setPos(vec(0,5,5))
	else
		root.RightArm:setPos():setRot()
		root.LeftArm:setPos():setRot()
	end
	
end)

vanilla_model.ALL:setVisible(false) -- disable normal player model
vanilla_model.HELD_ITEMS:setVisible(true) -- enable held items

local MP = action_wheel:newPage("MainPage")
MP:setAction(-1,require("scripts.page.Skins"))
MP:setAction(-1,require("scripts.page.Animations"))
action_wheel:setPage(MP)
