local page = action_wheel:newPage()
local prevPage

page:newAction()
  :title('GoBack')
  :item("minecraft:barrier")
  :onLeftClick(function() 
    action_wheel:setPage(prevPage) 
  end)
  
prev = nil
local function setSkin(n)
	local tex1 = textures[n]
	local tex2 = textures[n.."2"]
	for x,d in pairs(getDescendants(root)) do
		d:setPrimaryTexture("Custom",tex1)
	end
	root.Head.eyeglow:setPrimaryTexture("Custom",tex2)
	prev:setToggled(false)
end
  

function pings.classic()
	setSkin("textures.classic")
	classic:setToggled(true)
	prev = classic
end

function pings.main()
	setSkin("textures.main")
	main:setToggled(true)
	prev = main
end

function pings.spark()
	setSkin("textures.spark")
	spark:setToggled(true)
	prev = spark
end

function pings.mustard()
	setSkin("textures.mustard")
	mustard:setToggled(true)
	prev = mustard
end

main = page:newAction()
	:item("minecraft:iron_block")
	:title("Light")
	:onLeftClick(pings.main)
main:setToggled(true)
  
classic = page:newAction()
	:item("minecraft:grass_block")
	:title("Classic")
	:onLeftClick(pings.classic)
	
spark = page:newAction()
	:item("minecraft:fire_charge")
	:title("Spark")
	:onLeftClick(pings.spark)

mustard = page:newAction()
	:item("minecraft:yellow_candle")
	:title("Mustard")
	:onLeftClick(pings.mustard)

prev = main
  
return action_wheel:newAction()
  :title("Skins")
  :item("minecraft:iron_chestplate")
  :onLeftClick(function()
    prevPage=action_wheel:getCurrentPage()
    action_wheel:setPage(page)
  end)