vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("config-treesitter", { clear = true }),
	callback = function(args)
		local ok = pcall(vim.treesitter.start, args.buf)
		if not ok then
			return
		end

		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
