--*****************************************************************
--************************* START INIZER **************************
--*****************************************************************
-- Purpose: to have default .ini values and version control on configs
-- Personal ini file
-- if you want to use my ini file serializer just copy form start of inizer to end of inizer and look at how i implemented settings and go nuts :~D

-- Function to open a folder in Explorer
function openFolderInExplorer(folderPath)
    if folderPath then
        folderPath = '"' .. folderPath .. '"'
        os.execute('explorer ' .. folderPath)
    else
        yield("/echo Error: Folder path not provided.")
    end
end

function serialize(value)
    if type(value) == "boolean" then
        return tostring(value)
    elseif type(value) == "number" then
        return tostring(value)
    else -- Default to string
        return '"' .. tostring(value) .. '"'
    end
end

function deserialize(value)
    if value == "true" then
        return true
    elseif value == "false" then
        return false
    elseif tonumber(value) then
        return tonumber(value)
    else
        return value:gsub('^"(.*)"$', "%1")
    end
end

function read_ini_file()
    local variables = {}
    local file = io.open(filename, "r")
    if not file then
        return variables
    end

    for line in file:lines() do
        local name, val = line:match("([^=]+)=(.*)")
        if name and val then
            variables[name] = deserialize(val)
        end
    end
    file:close()
    return variables
end

function write_ini_file(variables)
    local file = io.open(filename, "w")
    if not file then
        yield("/echo Error: Unable to open file for writing: " .. filename)
        return
    end

    for name, value in pairs(variables) do
        file:write(name .. "=" .. serialize(value) .. "\n")
    end
    file:close()
end

function ini_check(varname, varvalue)
    local variables = read_ini_file()

    if variables["version"] and tonumber(variables["version"]) ~= vershun then
        yield("/echo Version mismatch. Recreating file.")
        variables = {version = vershun}
    end

    if variables[varname] == nil then
        variables[varname] = varvalue
        yield("/echo Initialized " .. varname .. " -> " .. tostring(varvalue))
    else
        yield("/echo Loaded " .. varname .. " -> " .. tostring(variables[varname]))
    end

    write_ini_file(variables)
    return variables[varname]
end

--*****************************************************************
--************************** END INIZER ***************************
--*****************************************************************


function become_feesher()
	yield("/equipitem 2571") --weathered fishing rod
	yield("/wait 0.5")
	yield("/equipitem 35393") --integral fishing rod
	yield("/wait 0.5")
	yield("/equipjob fsh")
	yield("/wait 0.5")
	--check if we can become fisher
	if GetItemCount(35393) == 0 and GetItemCount(2571) == 0 and GetClassJobId() ~= 18 then
		visland_stop_moving()
		yield("/vnavmesh moveto -246.67446899414 16.199998855591 41.268531799316")
		visland_stop_moving()
		yield("/echo No rod so we buy one and equip it!")
		yield("/target Syneyhil")
		yield("/wait 2")
		yield("/interact")
		yield("/wait 2")
		yield("/pcall SelectIconString true 1 <wait.2>")
		yield("/pcall SelectString true 0 <wait.2>")
		yield("/pcall Shop true 0 4 1 <wait.1.0>")
		yield("/pcall Shop true -1 <wait.1.0>")
		visland_stop_moving()
		ungabunga()
	end
	yield("/equipitem 2571") --weathered fishing rod
	yield("/wait 0.5")
	yield("/equipitem 35393") --integral fishing rod
	yield("/wait 0.5")
	yield("/equipjob fsh")
	yield("/wait 0.5")
	ungabunga()
	yield("/equipitem 2571") --weathered fishing rod
	yield("/wait 0.5")
	yield("/equipitem 35393") --integral fishing rod
	yield("/wait 0.5")
	yield("/equipjob fsh")
	yield("/wait 0.5")
end

function ungabunga()
	yield("/send ESCAPE <wait.1.5>")
	yield("/pcall SelectYesno true 0")
	yield("/send ESCAPE <wait.1.5>")
	yield("/pcall SelectYesno true 0")
	yield("/send ESCAPE <wait.1.5>")
	yield("/pcall SelectYesno true 0")
	yield("/send ESCAPE <wait.1>")
	yield("/pcall SelectYesno true 0")
	yield("/wait 3")
end

function zungazunga()
	yield("/send ESCAPE")
	yield("/wait 0.5")
	yield("/send ESCAPE")
	yield("/wait 0.5")
	yield("/send ESCAPE")
	yield("/wait 0.5")
end

function ungabungabunga()
	--don't bunga bunga if we are not ingame.. it breaks logging in
	while GetCharacterCondition(1) == false do
		yield("/wait 5") --wait 5 seconds to see if char condition 1 comes back.
	end
	if GetCharacterCondition(1) == true then
		tobungaorunga = 0
		while tobungaorunga == 0 do
			yield("/send ESCAPE <wait.1.5>")
			yield("/pcall SelectYesno true 0")
			yield("/send ESCAPE <wait.1.5>")
			yield("/pcall SelectYesno true 0")
			yield("/send ESCAPE <wait.1.5>")
			yield("/pcall SelectYesno true 0")
			yield("/send ESCAPE <wait.1>")
			yield("/wait 3")
			if IsPlayerAvailable() == true then
				tobungaorunga = 1
			end
		end
	end
end

function generateRandomLetter(cappy)
    local uppercase = math.random(65, 90) -- ASCII codes for uppercase letters
    local lowercase = math.random(97, 122) -- ASCII codes for lowercase letters
    local choice = math.random(0, 1) -- Randomly choose between uppercase and lowercase
	if cappy == 2 then choice = 0 end
	if cappy == 3 then choice = 1 end
    if choice == 0 then
        return string.char(lowercase)
    else
        return string.char(uppercase)
    end
end

--0=no, 1=full randomize, 2=lowercase only, 3=uppercase only, 4=randomly full upper OR lowercase, 5=pick from emblem configuration list. remember this has to be the FC leader
function generateFiveDigitText(frocess_tags)
    local text = ""
	capper = frocess_tags
	if capper == 4 then
		local choice = math.random(0, 1) -- Randomly choose between uppercase and lowercase
		choice = choice + 2
	end
    for i = 1, 5 do
        text = text .. generateRandomLetter(capper)
    end
    return text
end

function WalkTo(x, y, z)
	PathfindAndMoveTo(x, y, z, false)
	countee = 0
	while (PathIsRunning() or PathfindInProgress()) do
		yield("/wait 0.5")
		--if GetZoneID() == 130 or GetZoneID() == 341 then --130 is uldah. dont need to jump anymore it paths properly. we will test anyways.
		countee = countee + 1
		--yield("/echo we are still pathfinding apparently -> countee -> "..countee)
		if gachi_jumpy == 1 and countee == 10 and GetZoneID() ~= 129 then --we only doing jumps if we configured for it
		--if GetZoneID() == 341 then --only need to jump in goblet for now
			yield("/gaction jump")
			countee = 0
			yield("/echo we are REALLY still pathfinding apparently")
		end
	end
end

function ZoneTransition()
	yield("/automove off")
	iswehehe = IsPlayerAvailable() 
	iswoah = 0
    repeat 
        yield("/wait 0.5")
        yield("/echo Are we ready? -> "..iswoah.."/20")
		iswehehe = IsPlayerAvailable() 
		iswoah = iswoah + 1
		if 	iswoah == 5 then yield("/pcall SelectYesno true 0") end
		if 	iswoah == 10 then yield("/pcall SelectYesno true 0") end
		if 	iswoah == 15 then yield("/pcall SelectYesno true 0") end
		if 	iswoah == 20 then
			iswehehe = false
			yield("/pcall SelectYesno true 0")
		end
    until not iswehehe
	iswoah = 0
	yield("/automove off")
    repeat 
        yield("/wait 0.5")
        yield("/echo Are we ready? (backup check)-> "..iswoah.."/20")
		iswehehe = IsPlayerAvailable() 
		iswoah = iswoah + 1
		if 	iswoah == 5 then yield("/pcall SelectYesno true 0") end
		if 	iswoah == 10 then yield("/pcall SelectYesno true 0") end
		if 	iswoah == 15 then yield("/pcall SelectYesno true 0") end
		if 	iswoah == 20 then
			iswehehe = true
			yield("/pcall SelectYesno true 0")
		end
    until iswehehe
end

function WalkToGC()
    if GetPlayerGC() == 1 then --toilet
        if GetZoneID() ~= 128 then
			yield("/li The Aftcastle") 
		    ZoneTransition()
			if movementtype == 1 then --visland hackery
				yield("/visland exectemponce H4sIAAAAAAAACu2Wy07DMBBF/2XWkRU/Y2eHClQVaikFqTzEwlBXtZTEpXFAqOq/44ZE9LFDWSYrz53J6PrIGnsLE50bSGE4yGxeaohguHHVOigTV5gQzvX32tnCl5C+bGHqSuutKyDdwiOkWCEuZcIieIKUxSiO4BnShKCEYUV3IQpNRpeQhsRML2wVutB91dh9mtwUvs5MtV8tbbGAdKmz0kQwKrzZ6Hc/t3512/x+qDWeg7ty5b7aTLBVnrWoveIIrnLnWycjb/JmeVFXNMFdZUp/uL43H3Uwdm+NfO/deuCKRQMhKDc2ywauarYyc5U3x/bm2vo/X/vo2m2Oe+zFB5ubcaiLd9EZZsKRiqmK5QlniiRjuOfcFWeaIBnz5IwypxwT0R/njjAzgaSQmIsaNFVIhY+3sBnBVLAedkewhUAsID2b0JSJfnJ0NjkSjkigfHoRUkQEUbg/zB1hVhRRoqTgLWeScJr8subh0cFi2bP+F+vX3Q9/zfhXCwoAAA==")
				visland_stop_moving()
			end
		end
		if movementtype == 0 then --default navmesh
			WalkTo(94, 40.5, 74.5)
		end
    elseif GetPlayerGC() == 2 then --vampire coven
		if movementtype == 1 then --visland hackery
			yield("/li Archers' Guild") 
		    ZoneTransition()
			yield("/visland exectemponce H4sIAAAAAAAACu2ZTW/bMAyG/4vOKUGJokT5NnRbUQztunZA94EdssVdDTRxlzgbhqL/ffRXP7CdBh11M2VHoJ+8eE1Sd+Z0ua5NZY4Ov2+blVmYo227v9WF03ZTa3i5/H3bNptuZ6rPd+as3TVd025MdWc+mMp6gRREFuajqQ4QKDCLtbwwn0wlBIFiTPca6V7HL02FC3O+XDV73YxAg5P2Z72uN91w52zZXV81m5WprpY3u3phjjddvV1+6y6b7vrt9POna1PmmuTuuv0139Hsdn9tMaRsF+bVuu3mTI67ej1dvhiemIJ3+3rXPb2+qH8MwUn7dVq+6Nrbw3azmljoypvm5uaw3U+vct7uu/p5epfLpnvMq49et9vne/SL75t1faLP4f3ib9pOIEQf3IwbIwZFHgfcMQFah6HgzoXbekAXgwsPvMX7INGNvB1EywV3PtzqH8k6P9BW2APl4IEYrRRV58KMEUiCpQmzw6Q2IgNsFnD6DxRR56Wtvj1atgrcpuBp/D6yatwic5F2JtiJgaI4HB1E7ZkT+TB+HclDQC/FR3LBFobgUhpZE3hkN5iKstYyJXr2vig7F+zAkKLEgbWFIIgcRssmBFW5wi8ukok1B3Ae/ezYQekqe5ppE1GKRdm5aHsPTCh9DzN4NvuUAobRRyxof4MFdjbYDgQTyT9Y2wQxavfui49kgk064bCB7GTaY9PoSI08BSqUM1FWj3CCkWfKVgvs+MCamC0W2Pm6GW1gtMrrG5hxIpISOnI8WwglH22xkFy8D7zW1T7JzNsBueTF+pE3QwwoEouZ5OLtELRHdNOA1YMldP34r6dNIKrtMs7Op27SPtEFbctn3E766eqkbgtiQ3Kl+svGm0kJE0ea3URsfz4z6RsholYmZaCdjXewYJmJJn1rp44auL6P788PgEPSqLh3Nt4RtLl5LE703IBJHWbAfSDq3+hj0XdO3iye7RPegj7wzNt6F32pTv6P95f7P8KvqWabHwAA")
			visland_stop_moving()
		end
		if movementtype == 0 then --default navmesh
			WalkTo(-68.5, -0.5, -8.5)
		end
    elseif GetPlayerGC() == 3 then --best place in game
		if movementtype == 1 then --visland hackery
			yield("/li Thaumaturges' Guild") 
		    ZoneTransition()
			yield("/visland exectemponce H4sIAAAAAAAACu2WSWvDMBCF/8ucXWFJI8v2raQLoaQ7pAs9uI1CBLGVxnJLCfnvnTgKTZdT8dE+6b2Rh6cPMWgF50VpIIfTQTOfQASnS9csSJ+7ypAcFx8LZytfQ/64gktXW29dBfkK7iA/4EoxybnECO4h58jiWEXwADkmLFGayzUpajQ8gjyO4LqY2IY6SUZi5N5MaSrfVi4LP5vaagL5tJjXJoJh5c2yePFj62cX4fd9L6SmhPXMve8qFK3+1aLNyyM4Lp3fJRl6U4blYbsjiKvG1H5/fWNeWzFyz8G+8W4xcNUkgCDnzM7nA9eEo1y7xpvv8caF9V+5NurELb/32Ji3tjQj2hevoz9Qo2KxEkptUYsNQgLNU4YpatWT7pB0xhQK/EH6gCdMaMGl7i91Z6hlxhKOQv9ALemuo85S1aPuDLVARoOaJnbLGneoNdmJFog96u5QayZRpRnuUGf0od4CzwRLBZWTHnh3E1swjsQ08OYEPNUyjO1YsSxBepn0wP8F/Gn9CUAVPgMlCgAA")
			visland_stop_moving()
		end
		if movementtype == 0 then --default navmesh
			--WalkTo(-129.5, -1.9, -151.6)
			--WalkTo(-116, 2, -136.9)
			WalkTo(-141.7, 4.1, -106.8)
		end
    end
end

function TargetedInteract(target)
    yield("/target "..target.." <wait.0.5>")
    yield("/pinteract <wait.1>")
end

function DidWeLoadcorrectly()
	yield("/echo We loaded the functions file successfully!")
end

function CharacterSafeWait()
     yield("/echo 15 second wait for char swap")
	 yield("/wait 15")
	 yield("/waitaddon NamePlate <maxwait.600> <wait.5>")
	 --ZoneTransition()
end

function visland_stop_moving()
 do_we_force_equip = force_equipstuff or 1  --default is on, unless we specify the global force_equipstuff in the calling script
 if do_we_force_equip == 1 then
	 yield("/equipguud")
	 yield("/equiprecommended")
	 yield("/character")
	 yield("/pcall Character true 15")
	 yield("/wait 0.5")
	 yield("/pcall SelectYesno true 0")
	 yield("/character")
	 yield("/pcall Character true 15")
	 yield("/pcall SelectYesno true 0")
	 yield("/wait 3")
 end
 muuv = 1
 muuvX = GetPlayerRawXPos()
 muuvY = GetPlayerRawYPos()
 muuvZ = GetPlayerRawZPos()
 while muuv == 1 do
	yield("/wait 1")
	if muuvX == GetPlayerRawXPos() and muuvY == GetPlayerRawYPos() and muuvZ == GetPlayerRawZPos() then
		muuv = 0
	end
	muuvX = GetPlayerRawXPos()
	muuvY = GetPlayerRawYPos()
	muuvZ = GetPlayerRawZPos()
 end
 --yield("/echo movement stopped - time for GC turn ins or whatever")
 yield("/echo movement stopped safely - script proceeding to next bit")
 yield("/visland stop")
 yield("/vnavmesh stop")
 yield("/wait 3")
 --added becuase simpletweaks is slow to update :(
 if do_we_force_equip == 1 then
	 yield("/character")
	 yield("/wait 1")
	 yield("/pcall Character true 12")
	 yield("/wait 1")
	 yield("/pcall RecommendEquip true 0")
	 yield("/wait 1")
 end
end


function return_to_limsa_bell()
	yield("/tp Limsa Lominsa")
	ZoneTransition()
	yield("/wait 2")
	yield("/wait 1")
	yield("/pcall SelectYesno true 0")
	PathfindAndMoveTo(-125.440284729, 18.0, 21.004405975342, false)
	visland_stop_moving() --added so we don't accidentally end before we get to the inn person
end

function return_to_inn()
	yield("/tp New Gridania")
	ZoneTransition()
	yield("/wait 2")
	PathfindAndMoveTo(48.969123840332, -1.5844612121582, 57.311756134033, false)
	visland_stop_moving() --added so we don't accidentally end before we get to the inn person
	yield("/visland exectemponce H4sIAAAAAAAACu3WS4/TMBAA4L9S+RxGfo0fuaEFpBUqLLtIXUAcDPVSS01cEgeEqv53nDSlWxAHUI65eWxnNPlkjb0nr1zlSUm+NGHt6uAWO9ek4LaLFBehrklBVu7HLoY6taT8sCc3sQ0pxJqUe3JPSmnAKsu4LMg7Uj5hgEZKxXhB3pMSNQjGNKpDDmPtr5+Rkom8duvWocv5GNCCLOM3X/k6kTIHNy5tHkK9JmVqOl+Q6zr5xn1Oq5A2r/vv6eXcWH0us93E76eVXF/O/uC27aMUQ9GsIM+rmPwpVfLVOHw67BiDN51v0+Pxnf86BMv4aZy+S3F3Fev1qJFnXobt9ip245/cxi75y/JWLqRzXX30IjaXOfrJt6Hyy7yPHoo/vFGBEGj1kZuCNohIe/7srQwgo8hm7qm4FQObDzQ/cUtpKcU+ztwawQqrZ+3JtCVIjsIctTkwTRH1YG0E5GNOJc7ak2nz3D14Bj9yK1BaS4sDt0VApZWdtSdr3AwYNxbHVmKASmWVPnIzKkFwTs3fvMV8Uf6jt8TcrM3wEjl7SzNyCxDa6rmZTHa8uQWRH4LmzP3rYDPUcr4kp5PWoASXVv0uzYAzIebH339Kfzz8BLifXG8MDQAA")
	visland_stop_moving() --added so we don't accidentally end before we get to the inn person
	yield("/target Antoinaut")
	yield("/wait 0.5")
	yield("/interact")
end

function return_to_fc()
	--yield("/tp Estate Hall") --old way
	--yield("/tp Estate Hall (Free Company)") --new way notice the brackets
	yield("/li fc") --new way notice the brackets --this also respects house regisrtations in lifestream
	yield("/wait 1")
	--yield("/waitaddon Nowloading <maxwait.15>")
	yield("/wait 15")
	yield("/waitaddon NamePlate <maxwait.600><wait.5>")
end

function return_to_lair()
	--yield("/tp Estate Hall")
	yield("/tp Estate Hall (Private)")
	yield("/wait 1")
	--yield("/waitaddon Nowloading <maxwait.15>")
	yield("/wait 15")
	yield("/waitaddon NamePlate <maxwait.600><wait.5>")
end

function return_fc_entrance()
	yield("/target Entrance <wait.1>")
	yield("/vnav moveto "..GetTargetRawXPos().." "..GetTargetRawYPos().." "..GetTargetRawZPos())
	yield("/target Entrance <wait.1>")
	yield("/vnav moveto "..GetTargetRawXPos().." "..GetTargetRawYPos().." "..GetTargetRawZPos())
	yield("/wait 5")
	--commented out this garbage finally
--[[
	yield("/hold W <wait.1.0>")
	yield("/release W")
	yield("/target Entrance <wait.1>")
	yield("/interact")
	yield("/lockon on")
	yield("/automove on")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/automove off")
	yield("/hold Q")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/automove on")
	yield("/release Q")
	yield("/interact")
	yield("/hold Q")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 0.5")
	yield("/interact")
	yield("/interact")
	yield("/release Q")
	yield("/interact")
	yield("/wait 1")
	yield("/pcall SelectYesno true 0")
	--]]
end

function return_fc_near_bell()
	yield("/target \"Summoning Bell\"")
	yield("/wait 2")
	--PathfindAndMoveTo(GetObjectRawXPos("Summoning Bell"), GetObjectRawYPos("Summoning Bell"), GetObjectRawZPos("Summoning Bell"), false)
	WalkTo(GetObjectRawXPos("Summoning Bell"), GetObjectRawYPos("Summoning Bell"), GetObjectRawZPos("Summoning Bell"))
	visland_stop_moving() --added so we don't accidentally end before we get to the bell
end

function are_we_dol()
	is_it_dol = false
	yield("Our job is "..GetClassJobId())
	if type(GetClassJobId()) == "number" and GetClassJobId() > 7 and GetClassJobId() < 19 then
		is_it_dol = true
		yield("/echo We are a Disciple of the (H/L)and")
	end
	return is_it_dol
end

function which_cj()
	highest_cj = 0
	highest_cj_level = 0
	yield("Time to figure out which job ID to switch to !")
	for i=0,7 do
		if tonumber(GetLevel(i)) > highest_cj_level then
			highest_cj_level = GetLevel(i)
			highest_cj = i
			yield("/echo Oh my maybe job->"..i.." lv->"..highest_cj_level.." is the highest one?")
		end
	end
	for i=19,29 do
		if tonumber(GetLevel(i)) > highest_cj_level then
			highest_cj_level = GetLevel(i)
			highest_cj = i
			yield("/echo Oh my maybe job->"..i.." lv->"..highest_cj_level.." is the highest one?")
		end
	end
	return tonumber(highest_cj)
end

function job_short(which_cj)
	yield("Time to figure out which job shortname to switch to !")
	if which_cj == -1 then shortjob = "adv" end
	if which_cj == 1 then shortjob = "gld" 
		if GetItemCount(4542) > 0 then
			shortjob = "pld"
		end
	end
	if which_cj == 0 then shortjob = "pgl" 
		if GetItemCount(4543) > 0 then
			shortjob = "mnk"
		end
	end
	if which_cj == 2 then shortjob = "mrd" 
		if GetItemCount(4544) > 0 then
			shortjob = "war"
		end
	end
	if which_cj == 4 then shortjob = "lnc" 
		if GetItemCount(4545) > 0 then
			shortjob = "drg"
		end
	end
	if which_cj == 3 then shortjob = "arc" 
		if GetItemCount(4546) > 0 then
			shortjob = "brd"
		end
	end
	if which_cj == 6 then shortjob = "cnj" 
		if GetItemCount(4547) > 0 then
			shortjob = "whm"
		end
	end
	if which_cj == 5 then shortjob = "thm" 
		if GetItemCount(4548) > 0 then
			shortjob = "blm"
		end
	end
	if which_cj == 19 then shortjob = "rog" 
		if GetItemCount(7886) > 0 then
			shortjob = "nin"
		end
	end
	if which_cj == 20 then shortjob = "mch" end
	if which_cj == 21 then shortjob = "drk" end
	if which_cj == 22 then shortjob = "ast" end
	if which_cj == 23 then shortjob = "sam" end
	if which_cj == 24 then shortjob = "rdm" end
	if which_cj == 25 then shortjob = "blu" end
	if which_cj == 26 then shortjob = "gnb" end
	if which_cj == 27 then shortjob = "dnc" end
	if which_cj == 28 then shortjob = "rpr" end
	if which_cj == 29 then shortjob = "sge" end
	return shortjob
end

function enter_workshop()
	--[[ for later
	yield("/freecompanycmd")
	yield("/wait 1")
	fcPoints = string.gsub(GetNodeText("FreeCompany", 15),"",""):gsub(",", "")
	--]]
	--enter house
	yield("/wait 0.5")
	yield("/target Entrance")
	yield("/wait 0.5")
	yield("/interact")
	yield("/wait 5")
	--enter workshop
	yield("/target \"Entrance to Additional Chambers\"")
	--check to make sure we actually targeted the door to additional rooms.
	if GetTargetName() == "Entrance to Additional Chambers" then
		yield("/wait 0.5")
		yield("/lockon")
		yield("/automove")
		visland_stop_moving()
		yield("/interact")
		yield("/wait 1")
		yield("/pcall SelectString true 0")
		yield("/wait 5")
	end
end

function clean_inventory()
	--oh yeah you'll need this. and asking about it on punish will result in right click -> block.
	--https://raw.githubusercontent.com/ffxivcode/DalamudPlugins/main/repo.json
	--*start cleaning??? need slash command
	--*loop every 5 seconds and check if we have the right char condition to resume whatever we were doing.
	--/automarket start|stop
	zungazunga()
	yield("/target Summoning Bell")
	yield("/wait 1")
	yield("/lockon on")
	yield("/automove on <wait.5.0>") --sometimes it takes a while to path over 3.5 seconds worked in testing and even 1.5 and 2.5 seconds worked but we gonna do 5 seconds to cover all issues
	yield("/interact")
	yield("/automarket start")
	yield("/wait 5")
	yield("/target Summoning Bell")
	yield("/wait 1")
	yield("/interact")
--	yield("/automarket start")
	exit_cleaning = 0
	while GetCharacterCondition(50) == false and exit_cleaning < 20 do
		yield("/wait 1")
		exit_cleaning = exit_cleaning + 1
		yield("/echo Waiting for repricer to start -> "..exit_cleaning.."/20")
	end
	exit_cleaning = 0
	forced_am = 0
	bungaboard = SetClipboard("123123123")
	while GetCharacterCondition(50) == true and exit_cleaning < 300 do
		yield("/wait 1")
		exit_cleaning = exit_cleaning + 1
		flandom = getRandomNumber(1,20)
		--yield("/echo Waiting for repricer to end -> "..exit_cleaning.." seconds duration so far flandom -> "..flandom)
		yield("/echo Waiting for repricer to end -> "..exit_cleaning.."/300")
		forced_am = forced_am + 1
		if forced_am > 15 then --every 15 cycles we will update clipboard if it hasnt changed then we have a problem!
			yield("/echo Clipboard contains -> "..GetClipboard())
			if bungaboard == GetClipboard() then
				yield("/echo oops Automarket is stuck ! let's help it!")
				ungabunga()
				exit_cleaning = exit_cleaning + 25
			end
			bungaboard = GetClipboard()
			forced_am = 0
		end
	end
	CharacterSafeWait()
	zungazunga()
	if exit_cleaning > 250 then
		ungabungabunga()
	end
	yield("/automarket stop")
	yield("/wait 1")
end

function getRandomNumber(min, max)
  return math.random(min,max)
end

function try_to_buy_fuel(restock_amt)
	--target mammet
	yield("/wait 5")
	yield("/target mammet")
	yield("/wait 0.5")
	yield("/lockon")
	yield("/automove")
	visland_stop_moving()
	--open mammet menu
	yield("/automove off")
	yield("/interact")
	yield("/wait 2")
	yield("/pcall SelectIconString true 0")
	yield("/wait 2")
	--buy exactly restock_amt final value for fuel
	--grab current fuel total
	curFuel = GetItemCount(10155)
	oldFuel = curFuel + 1
	while curFuel < restock_amt do
		buyamt = 99 --this can be set to 231u if you want but i wouldn't recommend it as it shows on lodestone
		if (restock_amt - curFuel) < 99 then
			buyamt = restock_amt - curFuel
		end
		yield("/pcall FreeCompanyCreditShop false 0 0u "..buyamt.."u") 
		yield("/wait 1")
		oldFuel = curFuel
		curFuel = GetItemCount(10155)
		if oldFuel == curFuel then
			curFuel = restock_amt
			yield("/echo we ran out of FC points before finishing our purchases :(")
		end
	end
	yield("/echo We now have "..GetItemCount(10155).." Ceruelum Fuel Tanks")
	ungabunga()
end


function serializeTable(t, indent)
    indent = indent or ""
    local result = "{\n"
    local innerIndent = indent .. "  "

    for k, v in pairs(t) do
        result = result .. innerIndent
        if type(k) == "number" then
            result = result .. "[" .. k .. "] = "
        else
            result = result .. "[" .. tostring(k) .. "] = "
        end

        if type(v) == "table" then
            result = result .. serializeTable(v, innerIndent)
        elseif type(v) == "string" then
            result = result .. "\"" .. v .. "\""
        else
            result = result .. tostring(v)
        end

        result = result .. ",\n"
    end

    result = result .. indent:sub(1, -3) .. "}" -- Remove last comma and add closing brace
    return result
end


-- Function to deserialize a table
function deserializeTable(str)
    local func = load("return " .. str)
    return func()
end

function readSerializedData(filePath)
    local file, err = io.open(filePath, "r")
    if not file then
        yield("/echo Error opening file for reading: " .. err)
        return nil
    end
    local data = file:read("*all")
    file:close()
    return data
end

-- Function to print table contents
function printTable(t, indent)
    indent = indent or ""
    if type(t) ~= "table" then
        yield("/echo " .. indent .. tostring(t))
        return
    end
    
    for k, v in pairs(t) do
        local key = tostring(k)
        if type(v) == "table" then
            yield("/echo " .. indent .. key .. " =>")
            printTable(v, indent .. "  ") -- Recursive call with increased indent
        else
            yield("/echo " .. indent .. key .. " => " .. tostring(v))
        end
    end
end

function tablebunga(filename, tablename, path)
    local fullPath = path .. filename
    yield("/echo Debug: Full file path = " .. fullPath)
    
    local file, err = io.open(fullPath, "w")
    if not file then
        yield("/echo Error opening file for writing: " .. err)
        return
    end

    local tableToSerialize = _G[tablename]
    --yield("/echo Debug: Table to serialize = " .. tostring(tableToSerialize))

    if type(tableToSerialize) == "table" then
        local serializedData = serializeTable(tableToSerialize)
        --yield("/echo Debug: Serialized data:\n" .. serializedData)
        file:write(serializedData)
        file:close()
        yield("/echo Successfully wrote table to " .. fullPath)
    else
        yield("/echo Error: Table '" .. tablename .. "' not found or is not a table.")
    end
end

function FUTA_return()
		--limsa aetheryte
	if FUTA_processors[hoo_arr_weeeeee][1][2] == 4 then
		return_to_limsa_bell()
		yield("/wait 8")
	end
	
	--if we are tp to inn. we will go to gridania yo
	if FUTA_processors[hoo_arr_weeeeee][1][2] == 3 then
		return_to_inn()
		yield("/wait 8")
	end
	
	--options 1 and 2 are fc estate entrance or fc state bell so thats only time we will tp to fc estate
	if FUTA_processors[hoo_arr_weeeeee][1][2] == 0 or FUTA_processors[hoo_arr_weeeeee][1][2] == 1 then
		return_to_fc()
	end
	
	--option 5 or 6 personal home and bell near personal home
	if FUTA_processors[hoo_arr_weeeeee][1][2] == 5 or FUTA_processors[hoo_arr_weeeeee][1][2] == 6 then
		return_to_lair()
	end

	--normal small house shenanigans
	if FUTA_processors[hoo_arr_weeeeee][1][2] == 0 or FUTA_processors[hoo_arr_weeeeee][1][2] == 5 then
		return_fc_entrance()
	end

	--retainer bell nearby shenanigans
	if FUTA_processors[hoo_arr_weeeeee][1][2] == 1 or FUTA_processors[hoo_arr_weeeeee][1][2] == 6 then
		return_fc_near_bell()
	end	
	
end

function loggabunga(filename, texty)
	local file = io.open(folderPath .. filename .. "_log.txt", "a")
	if file then
		currentTime = os.date("*t")
		formattedTime = string.format("%04d-%02d-%02d %02d:%02d:%02d", currentTime.year, currentTime.month, currentTime.day, currentTime.hour, currentTime.min, currentTime.sec)
		file:write(formattedTime..texty.."\n")
		file:close()
	end
end

function check_ro_helm()
	--check for red onion helms and report in to a log file if there is one
	if GetItemCount(2820) > 0 then
		yield("/echo RED ONION HELM DETECTED")
		if FUTA_processors[hoo_arr_weeeeee][3][2] > 0 then
			FUTA_processors[hoo_arr_weeeeee][3][2] = 100 --force a cleaning next round as this will choke up the cleaning agent
		end
		loggabunga("FUTA_"," - Red Onion Helm detected on -> "..FUTA_processors[hoo_arr_weeeeee][1][1])
	end
end

function delete_my_items_please(how)
	if how == 0 then
		yield("/echo not deleting or desynthing items")
	end
	if how == 1 then
		yield("/echo Attempting to delete items")
		yield("/discardall")
	end
	if how == 2 then
		yield("/echo Attempting to desynth items")
		yield("/echo i dont know how to do this yet--*")
	end
end

function grab_aetheryte()
	yield("/target Aetheryte")
	yield("/wait 2")
	yield("/interact")
	yield("/wait 2")
	yield("/interact")
	yield("/wait 10")
end
