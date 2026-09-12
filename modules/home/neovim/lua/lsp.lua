require("fidget").setup({})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, event.buf)
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local servers = {
	clangd = {},
	basedpyright = {
		settings = {
			basedpyright = {
				analysis = {
					typeCheckingMode = "off",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "openFilesOnly",
				},
			},
		},
	},
	ruff = {
		on_attach = function(client)
			-- Disable hover in favor of basedpyright
			client.server_capabilities.hoverProvider = false
		end,
	},
	ts_ls = {
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		init_options = {
			preferences = {
				disableSuggestions = true, -- Disable suggestions to reduce noise
			},
		},
		settings = {
			javascript = {
				format = {
					enable = false,
				},
			},
			typescript = {
				format = {
					enable = false,
				},
			},
		},
	},
	lua_ls = {},
	taplo = {},
	bashls = {},
	-- Nix / flakes. nixd shells out to `nix eval` for flake-aware completion
	-- and option docs, and can also drive formatting/diagnostics through the
	-- formatter/nixpkgs settings below, but formatting is still routed
	-- through conform.nvim (see conform.lua) for consistency with the rest
	-- of the setup.
	nixd = {
		settings = {
			nixd = {
				nixpkgs = {
					expr = "import <nixpkgs> { }",
				},
				formatting = {
					command = { "alejandra" },
				},
			},
		},
	},
}

for server_name, server in pairs(servers) do
	server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
	vim.lsp.config(server_name, server)
end

vim.lsp.enable(vim.tbl_keys(servers))
