return {
	"adimit/prolog.vim",
	ft = "prolog",
	init = function()
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = "*.pl",
			callback = function()
				vim.bo.filetype = "prolog"
			end,
		})
	end,
}
