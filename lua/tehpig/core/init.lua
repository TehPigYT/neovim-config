require("tehpig.core.options")
require("tehpig.core.keymaps")

-- SFTP/Rsync Functions.
-- For Rsync the program itself needs to be installed on the system.
local function load_sync_config()
	local config_path = vim.fn.getcwd() .. "/.nvim-sync.json"
	if vim.fn.filereadable(config_path) == 0 then
		return nil
	end

	local file = io.open(config_path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()
	local ok, config = pcall(vim.fn.json_decode, content)
	if not ok then
		vim.notify("Invalid JSON in .nvim-sync.json", vim.log.levels.WARN)
		return nil
	end

	return config
end

local function project_sync()
	local config = load_sync_config()
	if not config then
		return
	end

	local file = vim.fn.expand("%:p")
	local remote = config.remote
	local cmd = ""

	if config.method == "rsync" then
		cmd = string.format("rsync -avz %s %s", file, remote)
	else
		cmd = string.format("sftp %s <<EOF\nput %s\nbye\nEOF", remote, file)
	end

	vim.fn.system(cmd)
	vim.notify("✅ Synced: " .. file)
end

vim.api.nvim_create_user_command("ProjectSync", project_sync, {})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		project_sync()
	end,
})
