local page = action_wheel:newPage()
AnimPage = page
local prevPage

page:newAction()
  :title('GoBack')
  :item("minecraft:barrier")
  :onLeftClick(function() 
    action_wheel:setPage(prevPage) 
  end)
  
local function getAnimation(animName)
	local c = animations:getAnimations()
	for x,d in pairs(c) do
		if d.name == animName then
			return d
		end
	end
	return nil
end
  
function pings.infamous()
	getAnimation('infamous'):play()
end

page:newAction()
	:item("minecraft:armor_stand")
	:title("Infamous Pose")
	:onLeftClick(pings.infamous)

  
return action_wheel:newAction()
  :title("Animations")
  :item("minecraft:sculk_sensor")
  :onLeftClick(function()
    prevPage=action_wheel:getCurrentPage()
    action_wheel:setPage(page)
  end)