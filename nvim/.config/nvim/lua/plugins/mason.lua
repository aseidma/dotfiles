return {
	{
		"williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "gopls"
            },
        },
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
	},
	"williamboman/mason-lspconfig.nvim"
}
