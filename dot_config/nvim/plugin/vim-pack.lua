local function pack_unused_plugins()
	local active_by_name = {}
	local unused = {}

	for _, plugin in ipairs(vim.pack.get()) do
		local name = plugin.spec and plugin.spec.name or nil
		if name then
			active_by_name[name] = plugin.active
		end
	end

	for _, plugin in ipairs(vim.pack.get()) do
		local name = plugin.spec and plugin.spec.name or nil
		if name and not active_by_name[name] then
			table.insert(unused, name)
		end
	end

	table.sort(unused)
	return unused
end

local function pack_clean()
	local unused = pack_unused_plugins()
	if #unused == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused)
	end
end

local function pack_list()
	local plugins = vim.pack.get()
	if not plugins or #plugins == 0 then
		print("No plugins found.")
		return
	end

	local unused_set = {}
	for _, name in ipairs(pack_unused_plugins()) do
		unused_set[name] = true
	end

	table.sort(plugins, function(a, b)
		local an = (a.spec and a.spec.name) or ""
		local bn = (b.spec and b.spec.name) or ""
		local au = unused_set[an] and 1 or 0
		local bu = unused_set[bn] and 1 or 0
		if au ~= bu then
			return au > bu -- unused first
		end
		return an < bn
	end)

	vim.ui.select(plugins, {
		prompt = "VimPack plugins",
		format_item = function(p)
			local name = (p.spec and p.spec.name) or "(unknown)"
			if unused_set[name] then
				return name .. " (unused)"
			end
			return name
		end,
	}, function(choice)
		if not choice then
			return
		end
		local name = (choice.spec and choice.spec.name) or "(unknown)"
		if unused_set[name] then
			print(name .. " (unused)")
		else
			print(name)
		end
	end)
end

-- pack clean - remove unused plugins
Config.map("n", "<leader>pc", pack_clean, { desc = "pack clean" })

-- pack list - show current plugins (uses vim.ui.select; telescope-ui-select will render it)
Config.map("n", "<leader>pl", pack_list, { desc = "pack list" })

Config.map("n", "<leader>pu", function()
	vim.pack.update()
end, { desc = "pack update" })
