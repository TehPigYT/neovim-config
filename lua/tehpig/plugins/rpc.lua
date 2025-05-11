return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	config = function()
		local cord = require("cord")

		cord.setup({
			display = {
				theme = "catppuccin",
			},
		})
	end,
}
