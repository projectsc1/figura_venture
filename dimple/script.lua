local ArmorAPI=require("scripts.armor.KattArmorAPI")

ArmorAPI.addHelmet(models.model.Head.Helmet) -- select helmet parts

ArmorAPI.onChange:register(function(b,c,d)
	if c == 'HELMET' and b.visible == true then
		models.model.Head.spiritflame:setVisible(false)
	elseif c == 'HELMET' and b.visible == false then
		models.model.Head.spiritflame:setVisible(true)
	end
end)
vanilla_model.ALL:setVisible(false) -- disable normal player model
vanilla_model.HELD_ITEMS:setVisible(true) -- enable held items