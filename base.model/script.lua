local ArmorAPI=require("scripts.armor.KattArmorAPI")

ArmorAPI.addHelmet(models.model.Head.Helmet) -- select helmet parts
ArmorAPI.addChestplate( -- select chestplate parts
  models.model.Body.Chestplate,
  models.model.RightArm.RightArmArmor,
  models.model.LeftArm.LeftArmArmor
)
ArmorAPI.addLeggings( -- select leggigns parts
  models.model.Body.Belt,
  models.model.RightLeg.RightLegArmor,
  models.model.LeftLeg.LeftLegArmor
)
ArmorAPI.addBoots( -- select boots parts
  models.model.RightLeg.RightBoot,
  models.model.LeftLeg.LeftBoot
)

vanilla_model.ALL:setVisible(false) -- disable normal player model
vanilla_model.HELD_ITEMS:setVisible(true) -- enable held items