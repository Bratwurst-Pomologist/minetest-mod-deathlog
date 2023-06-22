local dlhuds = {}

local function hud_add(killer, texture, victim)
	for _,player in ipairs(core.get_connected_players()) do
		local name = player:get_player_name()
		if type(dlhuds[name]) ~= "table" then
			dlhuds[name] = {}
		end
		for i,huds in ipairs(dlhuds[name]) do
			player:hud_change(huds[1],"position",{x = 0.78, y = 0.9 - i/30})
			player:hud_change(huds[2],"position",{x = 0.79, y = 0.9 - i/30})
			player:hud_change(huds[3],"position",{x = 0.8, y = 0.9 - i/30})
		end
		local huds = {}
		huds[1] = player:hud_add({
			hud_elem_type = "text",
			position = {x = 0.78, y = 0.9},
			text = killer,
			number = 0xFFFF00,
			scale = {x = 1, y = 1},
			alignment = {x = -1, y = 0},
			offset = {x = 1, y = 0},
			size = {x = 1, y = 1},
			style = 0
		})
		huds[2] = player:hud_add({
			hud_elem_type = "image",
			position = {x = 0.79, y = 0.9},
			text = texture,
			scale = {x = 1.7, y = 1.7},
			alignment = {x = 0, y = 0},
			offset = {x = 1, y = 0},
		})
		huds[3] = player:hud_add({
			hud_elem_type = "text",
			position = {x = 0.8, y = 0.9},
			text = victim,
			number = 0xFFFF00,
			scale = {x = 1, y = 1},
			alignment = {x = 1, y = 0},
			offset = {x = 1, y = 0},
			size = {x = 1, y = 1},
			style = 0
		})
		table.insert(dlhuds[name],huds)
		core.after(10,function()
			for _,hud in ipairs(huds) do
				player:hud_remove(hud)
			end
			table.remove(dlhuds[name],1)
		end)
	end
end

core.register_on_dieplayer(function(player, reason)
	local name = player:get_player_name()
	if reason.type == "set_hp" or reason.type == "fall" then
		hud_add("","deathlog_wasted.png",name)
	end
	if reason.type == "node_damage" then
		hud_add("",core.registered_nodes[reason.node].tiles[1],name)
	end
	if reason.type == "drown" then
		hud_add("","bubble.png",name)
	end
	if reason.type == "punch" then
		local obj = reason.object
		if obj:is_player() then
			local weapon = obj:get_wielded_item():get_name()
			local weap_tex = core.registered_items[weapon] and core.registered_items[weapon].inventory_image
			if not weap_tex or weap_tex == "" then
				weap_tex = core.registered_nodes[weapon] and core.registered_nodes[weapon].tiles[1]
			end
			if weapon == "" or not weap_tex or weap_tex == "" then
				weap_tex = "wieldhand.png"
			end
			local killer = obj:get_player_name()
			hud_add(killer,weap_tex.."^[resize:16x16",name)
		else
			local mob = obj:get_luaentity()
			if not mob then return end
			hud_add(mob.name,"default_tool_steelsword.png",name)
		end
	end

end)
