local ArmorAPI=require("scripts.armor.KattArmorAPI")

ArmorAPI.addHelmet(models.model.Head.Helmet) -- select helmet parts

ArmorAPI.onChange:register(function(b)
	log(b)
end)
vanilla_model.ALL:setVisible(false) -- disable normal player model
vanilla_model.HELD_ITEMS:setVisible(true) -- enable held items