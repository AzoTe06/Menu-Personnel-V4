---------------------------------- VAR ----------------------------------

playing_emote = false
local backlock = false
local personnelmenu = {
  opened = false,
  title = "Menu Personnel",
  currentmenu = "main",
  lastmenu = nil,
  currentpos = nil,
  selectedbutton = 0,
  marker = { r = 0, g = 0, b = 0, a = 200, type = 1 },
  menu = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    buttons = 8,
    from = 1,
    to = 8,
    scale = 0.4,
    font = 0,
    ["main"] = { 
      title = "CATEGORIES", 
      name = "main",
      buttons = { 
        {name = "Animations", title = "Animations"},
        {name = "GPS", title = "GPS"},
        {name = "phoneMenu", title = "Télépone"},        
        {name = "cartemenu", title = "Ma carte d'identité"},        
        {name = "Saver", title = "Sauvegarder ma position"},        
        {name = "close", title = "Fermer le menu"},
      }
    },
    ["Animations"] = { 
      title = "ANIMATIONS", 
      name = "Animations",
      buttons = {
        {name = "Stop", title = "Stopper l'animation"},
        {name = "Animation", title = "Applaudire", anim = "WORLD_HUMAN_CHEERING"},
        {name = "Animation", title = "Croiser les mains", anim = "WORLD_HUMAN_HANG_OUT_STREET"},        
        {name = "Animation", title = "Fumer une clope", anim = "WORLD_HUMAN_SMOKING"},
        {name = "Animation", title = "Faire un jogging", anim = "WORLD_HUMAN_JOG"},          
        {name = "Animation", title = "Boire un coup", anim = "WORLD_HUMAN_DRINKING"},
        {name = "Animation", title = "Faire du yoga", anim = "WORLD_HUMAN_YOGA"},
        {name = "Animation", title = "Faire des pompes", anim = "WORLD_HUMAN_PUSH_UPS"},
        {name = "Animation", title = "Faire des abdos", anim = "WORLD_HUMAN_SIT_UPS"},         
        {name = "Animation", title = "Jouer de la musique", anim = "WORLD_HUMAN_MUSICIAN"},
        {name = "Animation", title = "S'assoir", anim = "WORLD_HUMAN_PICNIC"}, 
        {name = "Animation", title = "Super", anim = "THANKS_MALE_06"},  
        {name = "back", title = "Retour"},                    
        -- FR -- Pour ajouter une animation il vous suffit de créer un bouton (title = Nom du bouton, anim = L'animation joué) -- EN -- To add an animation you just have to create a button (title = Name of the button, anim = The animation played)
        -- {name = "Animation", title = "Example", anim = "WORLD_HUMAN_EXAMPLE"},
      }
    },
    ["GPS"] = {
      title = "GPS",
      name = "GPS",
      buttons = {
        {name = "pole", title = "Pole Emploi"},
        {name = "concepoint", title = "Concessionnaire"},
        {name = "comico", title = "Commissariat"},
        {name = "hopi", title = "Hopital"},
        {name = "supr", title = "Suprimer le point"},
        {name = "back", title = "Retour"},
      }
    },
    ["cartemenu"] = {
      title = "CARTE D'IDENTITE",
      name = "cartemenu",
      buttons = {
        {name = "carte", title = "Voir ma carte d'identité"},
        {name = "back", title = "Retour"},		
      }
    },		
  }
}





-------------------------------------------------------------------------


function phoneMenu()
   TriggerEvent('phone:toggleMenu') 
end


---------------------------------- SAVER ----------------------------------

function Saver()
  LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
  local LastPosH = GetEntityHeading(GetPlayerPed(-1))
  TriggerServerEvent("project:savelastpos", LastPosX , LastPosY , LastPosZ, LastPosH)
end

--------------------------------- CARTE -----------------------------------------------

function carte()
  --SetNuiFocus(true)
  TriggerServerEvent('gc:openMeIdentity')
  SendNUIMessage({method = 'openGuiIdentity',  data = data})
  menuIsOpen = 1
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end



---------------------------------- GPS ----------------------------------

RegisterNetEvent("supr")
AddEventHandler("supr", function() 
end)

function supr()
  TriggerServerEvent("suprs")
  x, y, z = x, y, z
  SetWaypointOff(x, y, z)
end

RegisterNetEvent("comico")
AddEventHandler("comico", function() 
end)

function comico()
  TriggerServerEvent("comicos")
  x, y, z = 462.319854736328, -989.413513183594, 24.9148712158203
  SetNewWaypoint(x, y, z)
end


RegisterNetEvent("hopi")
AddEventHandler("hopi", function() 
end)

function hopi()
  TriggerServerEvent("hopis")
  x, y, z = 356.979156494141, -596.751220703125, 28.7816715240479
  SetNewWaypoint(x, y, z)
end


RegisterNetEvent("concepoint")
AddEventHandler("concepoint", function() 
end)

function concepoint()
  TriggerServerEvent("concepoints")
  x, y, z = -34.2844390869141, -1101.75170898438, 26.4223537445068
  SetNewWaypoint(x, y, z)
end

RegisterNetEvent("pole")
AddEventHandler("pole", function() 
end)

function pole()
  TriggerServerEvent("poles")
  x, y, z = -266.775268554688, -959.946960449219, 31.2197742462158
  SetNewWaypoint(x, y, z)
end

RegisterNetEvent('project:notify')
RegisterNetEvent("project:spawnlaspos")

local firstspawn = 0
local loaded = false

--Boucle Thread d'envoie de la position toutes les x secondes vers le serveur pour effectuer la sauvegarde
Citizen.CreateThread(function ()
  while true do
  --Durée entre chaque requêtes : 60000 = 60 secondes
  Citizen.Wait(60000)
    --Récupération de la position x, y, z du joueur
    LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    --Récupération de l'azimut du joueur
      local LastPosH = GetEntityHeading(GetPlayerPed(-1))
    --Envoi des données vers le serveur
      TriggerServerEvent("project:savelastpos", LastPosX , LastPosY , LastPosZ, LastPosH)
  end
end)

--Event permetant au serveur d'envoyez une notification au joueur
RegisterNetEvent('project:notify')
AddEventHandler('project:notify', function(alert)
    if not origin then
        Notify(alert)
    end
end)

--Notification joueur
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

--Event pour le spawn du joueur vers la dernière position connue
AddEventHandler("project:spawnlaspos", function(PosX, PosY, PosZ)
  if not loaded then
    SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 1, 0, 0, 1)
    Notify("~h~~g~Vous voici à votre dernière position")
  end
end)

--Action lors du spawn du joueur
AddEventHandler('playerSpawned', function(spawn)
--On verifie que c'est bien le premier spawn du joueur
if firstspawn == 0 then
  TriggerServerEvent("project:SpawnPlayer")
  firstspawn = 1
end
end) 

---------------------------------- FUNCTION ----------------------------------
function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y) 
end

function f(n)
  return n + 0.0001
end

function LocalPed()
  return GetPlayerPed(-1)
end

function try(f, catch_f)
local status, exception = pcall(f)
if not status then
  catch_f(exception)
end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
  boughtcar = false
  personnelmenu.currentmenu = "main"
  personnelmenu.opened = true
  personnelmenu.selectedbutton = 0
end

function CloseCreator()
  Citizen.CreateThread(function()
    local ped = LocalPed()
    if not boughtcar then
      local pos = currentlocation.pos.entering
    else
            
    end
    personnelmenu.opened = false
    personnelmenu.menu.from = 1
    personnelmenu.menu.to = 8
  end)
end

function drawMenuButton(button,x,y,selected)
  local menu = personnelmenu.menu
  SetTextFont(menu.font)
  SetTextProportional(0)
  SetTextScale(menu.scale, menu.scale)
  if selected then
    SetTextColour(0, 0, 0, 255)
  else
    SetTextColour(255, 255, 255, 255)
  end
  SetTextCentre(0)
  SetTextEntry("STRING")
  AddTextComponentString(button.title)
  if selected then
    DrawRect(x,y,menu.width,menu.height,255,255,255,255)
  else
    DrawRect(x,y,menu.width,menu.height,0,0,0,150)
  end
  DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)  
end

function drawMenuInfo(text)
  local menu = personnelmenu.menu
  SetTextFont(menu.font)
  SetTextProportional(0)
  SetTextScale(0.45, 0.45)
  SetTextColour(255, 255, 255, 255)
  SetTextCentre(0)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
  DrawText(0.365, 0.934)  
end

function drawMenuRight(txt,x,y,selected)
  local menu = personnelmenu.menu
  SetTextFont(menu.font)
  SetTextProportional(0)
  SetTextScale(menu.scale, menu.scale)
  SetTextRightJustify(1)
  if selected then
    SetTextColour(0, 0, 0, 255)
  else
    SetTextColour(0, 0, 0, 255)
  end
  SetTextCentre(0)
  SetTextEntry("STRING")
  AddTextComponentString(txt)
  DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028) 
end

function drawMenuTitle(txt,x,y)
local menu = personnelmenu.menu
  SetTextFont(2)
  SetTextProportional(0)
  SetTextScale(0.5, 0.5)
  SetTextColour(255, 255, 255, 255)
  SetTextEntry("STRING")
  AddTextComponentString(txt)
  DrawRect(x,y,menu.width,menu.height,0,0,0,150)
  DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)  
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


-- FR -- Fonction : Permet d'envoyer une notification à l'utilisateur
-- FR -- Paramètre(s) : text = Texte à afficher dans la notification
---------------------------------------------------------
-- EN -- Function : Sends a notification to the user
-- EN -- Param(s) : text = Text to display in the notification
function Notify(text)
  SetNotificationTextEntry('STRING')
  AddTextComponentString(text)
  DrawNotification(false, false)
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
  local ped = GetPlayerPed(-1)
  local this = personnelmenu.currentmenu
  local btn = button.name
  if this == "main" then
    if btn == "GPS" then
      OpenMenu('GPS')
    elseif btn == 'Animations' then
      OpenMenu('Animations')      
    elseif btn == 'Saver' then
       Saver()
       boughtcar = true               
    elseif btn == 'close' then
      CloseCreator()
      boughtcar = true    
    elseif btn == 'phoneMenu' then
      phoneMenu()
      boughtcar = true
      CloseCreator()
    elseif btn == 'cartemenu' then
       OpenMenu('cartemenu')
    end    
  elseif this == 'cartemenu' then
    if btn == 'carte' then
       carte()
       boughtcar = true
    elseif btn == 'closeGui' then
       closeGui()
       boughtcar = true
    elseif btn == "back" then
       OpenCreator()
       Back()
       boughtcar = true            	   
    end                                             
  elseif this == "GPS" then
    if btn == "pole" then
       pole()
       boughtcar = true
    elseif btn == "concepoint" then
       concepoint()
       boughtcar = true
    elseif btn == "comico" then
       comico()
       boughtcar = true
    elseif btn == "hopi" then
       hopi()
       boughtcar = true
    elseif btn == "supr" then
       supr()
       boughtcar = true                 
    elseif btn == "back" then
       OpenCreator()
       boughtcar = true
    end    
  elseif this == "Animations" then
    if btn == "Stop" then
        boughtcar = true
        ClearPedTasks(ped);
        playing_emote = false
    elseif btn == "back" then
        OpenCreator()
        boughtcar = true
    elseif btn == "Animation" then
        ped = GetPlayerPed(-1);
        if ped then
          TaskStartScenarioInPlace(ped, button.anim, 0, true);
          playing_emote = true;
        end
      end
     
  end
end

function OpenMenu(menu)
  personnelmenu.lastmenu = personnelmenu.currentmenu
  if menu == "Contact" then
    personnelmenu.lastmenu = "main"
  elseif menu == "main"  then
    personnelmenu.lastmenu = nil
  elseif menu == "ActionContact"  then
    personnelmenu.lastmenu = "Contact"
  elseif menu == "Animations" then
    personnelmenu.lastmenu = "main"
  end
  personnelmenu.menu.from = 1
  personnelmenu.menu.to = 8
  personnelmenu.selectedbutton = 0
  personnelmenu.currentmenu = menu
end


function Back()
  if backlock then
    return
  end
  backlock = true
  if personnelmenu.currentmenu == "main" then
    boughtcar = true
    CloseCreator()
  elseif personnelmenu.currentmenu == "Contact" then
    OpenMenu(personnelmenu.lastmenu)
  elseif personnelmenu.currentmenu == "Animations" then
    OpenMenu(personnelmenu.lastmenu)
  elseif personnelmenu.currentmenu == "ActionContact" then
    OpenMenu(personnelmenu.lastmenu)
  else
    OpenMenu(personnelmenu.lastmenu)
  end
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 128, 0, 150,255)
  SetTextEdge(1, 0, 128, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

---------------------------------- CITIZEN ----------------------------------

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1,288) then -- FR -- Modifier la valeur 202 pour modifier la touche sur le quel le joueur doit appuyer pour afficher le menu -- EN -- Change the value 202 to change the key on which the player must press to display the menu
      if personnelmenu.opened then
        CloseCreator()
      else
        OpenCreator()
      end
    end
    if personnelmenu.opened then
      local ped = LocalPed()
      local menu = personnelmenu.menu[personnelmenu.currentmenu]
      drawTxt(personnelmenu.title,1,1,personnelmenu.menu.x,personnelmenu.menu.y,1.0, 255,255,255,255)
      drawMenuTitle(menu.title, personnelmenu.menu.x,personnelmenu.menu.y + 0.08)
      drawTxt(personnelmenu.selectedbutton.."/"..tablelength(menu.buttons),0,0,personnelmenu.menu.x + personnelmenu.menu.width/2 - 0.0385,personnelmenu.menu.y + 0.067,0.4, 255,255,255,255)
      local y = personnelmenu.menu.y + 0.12
      buttoncount = tablelength(menu.buttons)
      local selected = false
      
      for i,button in pairs(menu.buttons) do
        if i >= personnelmenu.menu.from and i <= personnelmenu.menu.to then
          
          if i == personnelmenu.selectedbutton then
            selected = true
          else
            selected = false
          end
          drawMenuButton(button,personnelmenu.menu.x,y,selected)
          y = y + 0.04
          if selected and IsControlJustPressed(1,201) then
            ButtonSelected(button)
          end
        end
      end 
    end
    if personnelmenu.opened then
      if IsControlJustPressed(1,202) then 
        Back()
      end
      if IsControlJustReleased(1,202) then
        backlock = false
      end
      if IsControlJustPressed(1,188) then
        if personnelmenu.selectedbutton > 1 then
          personnelmenu.selectedbutton = personnelmenu.selectedbutton -1
          if buttoncount > 8 and personnelmenu.selectedbutton < personnelmenu.menu.from then
            personnelmenu.menu.from = personnelmenu.menu.from -1
            personnelmenu.menu.to = personnelmenu.menu.to - 1
          end
        end
      end
      if IsControlJustPressed(1,187)then
        if personnelmenu.selectedbutton < buttoncount then
          personnelmenu.selectedbutton = personnelmenu.selectedbutton +1
          if buttoncount > 8 and personnelmenu.selectedbutton > personnelmenu.menu.to then
            personnelmenu.menu.to = personnelmenu.menu.to + 1
            personnelmenu.menu.from = personnelmenu.menu.from + 1
          end
        end 
      end
    end
    
  end
end)