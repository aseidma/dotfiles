return {
	{
		"williamboman/mason.nvim",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
	},
	"williamboman/mason-lspconfig.nvim"
}
