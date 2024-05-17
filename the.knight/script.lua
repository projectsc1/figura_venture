local ArmorAPI=require("scripts.armor.KattArmorAPI")
root = models.model.root


ArmorAPI.addHelmet(root.Head.Helmet)
ArmorAPI.addChestplate(
  root.Body.Chestplate,
  root.RightArm.RightArmArmor,
  root.LeftArm.LeftArmArmor
)
ArmorAPI.addLeggings(
  root.Body.Belt,
  root.RightLeg.RightLegArmor,
  root.LeftLeg.LeftLegArmor
)
ArmorAPI.addBoots(
  root.RightLeg.RightBoot,
  root.LeftLeg.LeftBoot
)

events.render:register(function(t,ctx)
	renderer:offsetCameraPivot(vec(0,-0.35,0))
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
	
	--if #(animations:getPlaying()) > 0 then
	--	if vel:length() > 0.05 then
	--		animations:stopAll()
	--	end
	--end
	
	if ctx == "FIRST_PERSON" then
		root.RightArm:setPos(vec(0,5,5))
	else
		root.RightArm:setPos():setRot()
		root.LeftArm:setPos():setRot()
	end
	
end)

vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)