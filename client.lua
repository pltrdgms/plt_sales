local PLT = plt_sales
SalesMenu = MenuV:CreateMenu(false, "Komisyoncu", 'topright', 0, 0, 0, 'size-150', 'example', 'menuv', 'SalesMenu')

Citizen.CreateThread(function() 
  local bekle = 0
  local playerCoords = GetEntityCoords(PlayerPedId())
  local dist
  while true do 
    playerCoords = GetEntityCoords(PlayerPedId())
    bekle = 1000
    for k,v in pairs(PLT.Info) do 
      dist = GetDistanceBetweenCoords(playerCoords, v.coord, true)
      if dist < 10 then bekle = 0
        DrawMarker(6,v.coord.x,v.coord.y,v.coord.z-1,0.0, 0.0, 0.0,-90,-90,-90, 2.0,2.0,2.0,255,0.0,0.0,100,false, true, 2, false, false, false, false) 
        
        if dist < 1 then
          DrawText3Ds( v.coord.x,v.coord.y,v.coord.z, 0.35, 0.35,   "~b~(~y~-~g~E~y~-~b~) ~b~[~y~- ~g~ "..v.text.." ~y~-~b~]")
          if IsControlPressed(0,46)  then
            OpenMenu(v)  
          end
        else
          DrawText3Ds( v.coord.x,v.coord.y,v.coord.z, 0.35, 0.35,   " ~b~[~y~- ~g~ "..v.text.." ~y~-~b~]")
        end
      end
    end
    Citizen.Wait(bekle)
  end
end)


Citizen.CreateThread(function() 



  for i=1, #PLT.Info, 1 do
    if PLT.Info[i].blip ~= false then
      local blip = AddBlipForCoord(PLT.Info[i].coord.x, PLT.Info[i].coord.y, PLT.Info[i].coord.z)
      SetBlipSprite (blip, 480)
      SetBlipColour (blip, 46)
      SetBlipScale  (blip, 0.8)
      SetBlipAsShortRange(blip, true)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(PLT.Info[i].blip)
      EndTextCommandSetBlipName(blip)
    end
  end
end)


function DrawText3Ds(x,y,z, sx, sy, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(sx, sy)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 500
	DrawRect(_x,_y+0.0125, 0.0002+ factor, 0.025, 0, 0, 0, 50)
end




function OpenMenu(info)
	SalesMenu:Close() 
	SalesMenu:ClearItems()
  for k,v in pairs(info.items) do
    SalesMenu:AddButton({ 
      icon = '🎑',
      label = ('<span style="color:yellow;"><b>')..v.label.." "..v.price.."$"..('</span></b>'),
      value = "cancel",
      description =('<span style="color:blue;"><b>')..v.label.."' satmak için seçin."..('</span></b>'),
      select = function(i)   
        SalesMenu:Close() 
        TriggerServerEvent("plt_plants:plt_sales",k,v.price,v.label)
      end 
    })
  end

	SalesMenu:AddButton({ 
		icon = '⛔',
		label = ('<span style="color:red;"><b>').."Kapat"..('</span></b>'),
		value = "cancel",
		description =('<span style="color:red;"><b>').."Menüyü kapat"..('</span></b>'),
		select = function(i)   
			SalesMenu:Close() 
		end 
	})
	MenuV:OpenMenu(SalesMenu)
end







