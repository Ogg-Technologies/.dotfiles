return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {'williamboman/mason.nvim'},           -- Optional
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    },
    config = function()
        local lsp = require("lsp-zero")

        lsp.preset("recommended")

        lsp.ensure_installed({
            'lua_ls',
            'pyright'
        })

        -- Fix Undefined global 'vim'
        lsp.configure('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = {
                    globals = { 'vim' }
                    }
                }
            }
        })


        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}
        local cmp_mappings = lsp.defaults.cmp_mappings({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        })

        cmp_mappings['<Tab>'] = nil
        cmp_mappings['<S-Tab>'] = nil

        lsp.setup_nvim_cmp({
            mapping = cmp_mappings
        })

        lsp.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr, remap = false}

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>va", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vu", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format)

            local diagnostics_active = true
            vim.keymap.set('n', '<leader>vt', function()
                diagnostics_active = not diagnostics_active
                if diagnostics_active then
                    vim.diagnostic.show()
                    print("Diagnostics on")
                else
                    vim.diagnostic.hide()
                    print("Diagnostics off")
                end
            end)
        end)

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = true
        })
    end
}
