--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
    enabled = true,
    pattern = "*.lua",
    timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"


lvim.keys.insert_mode["jk"] = "<Esc>"
lvim.keys.insert_mode["kj"] = "<Esc>"
lvim.keys.insert_mode["<C-h>"] = vim.lsp.buf.signature_help
lvim.keys.normal_mode["U"] = "<C-r>"

lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

lvim.builtin.which_key.mappings["z"] = { "<cmd>set wrap!<cr>", "Toggle Word Wrap" }

-- vim.keymap.set("n", "<M>o", ":ClangdSwitchSourceHeader<CR>", { buffer = true })
-- clangd
lvim.keys.normal_mode['<M-o>'] = ":ClangdSwitchSourceHeader<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
lvim.colorscheme = "github_dark_dimmed"
-- lvim.transparent_window = true

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
--lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--return server ~= "ruff_lsp"
--end, lvim.lsp.automatic_configuration.skipped_servers)
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>

-- lvim.lsp.on_attach_callback = function(client, bufnr)
--     -- local function buf_set_option(...)
--     --     vim.api.nvim_buf_set_option(bufnr, ...)
--     -- end
--     -- --Enable completion triggered by <c-x><c-o>
--     -- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
--     if client.name == 'clangd' then
--         local cmakedir = vim.fn.findfile('CMakeLists.txt', vim.fn.getcwd() .. ";")
--         if cmakedir ~= "" then
--             vim.keymap.set("n", "<C-b>", function()
--                 vim.cmd('!cd build && make')
--             end, { buffer = true })
--             vim.keymap.set({ "n", "i" }, "<F5>", function()
--                 vim.cmd('!cd build && make run')
--             end, { buffer = true })
--             vim.keymap.set("n", "<M>o", ":ClangdSwitchSourceHeader<CR>", { buffer = true })
--         end
--     end
-- end

-- https://github.com/olrtg/dotfiles/blob/3bdef32246d7faa713ef32aae461037803cad97c/lvim/lua/user/languages/web.lua#L97
lvim.autocommands = {
    {
        "FileType",
        {
            pattern =
            "astro,css,eruby,html,htmldjango,javascript,javascriptreact,less,pug,sass,scss,svelte,typescriptreact,vue,php",
            callback = function()
                vim.lsp.start({
                    cmd = { "emmet-language-server", "--stdio" },
                    root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
                    init_options = {
                        --- @type table<string, any> https://docs.emmet.io/customization/preferences/
                        preferences = {},
                        --- @type "always" | "never" Defaults to `"always"`
                        showExpandedAbbreviation = "always",
                        --- @type boolean Defaults to `true`
                        showAbbreviationSuggestions = true,
                        --- @type boolean Defaults to `false`
                        showSuggestionsAsSnippets = false,
                        --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
                        syntaxProfiles = {},
                        --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
                        variables = {},
                        --- @type string[]
                        excludeLanguages = {},
                    },
                })
            end,
        },
    },
}

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    -- { command = "stylua" },
    {
        command = "prettierd",
        -- extra_args = { "--print-width", "100" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    },
    {
        command = "black",
        filetypes = { "python" },
    }
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { command = "flake8", filetypes = { "python" } },
    -- { command = "ruff",  args = { "check" }, filetypes = { "python" } },
    {
        command = "shellcheck",
        args = { "--severity", "warning" },
    },
    { command = "eslint" }
}

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
    -- {
    --     "folke/trouble.nvim",
    --     cmd = "TroubleToggle",
    -- },
    {
        "tpope/vim-surround",

        -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
        -- setup = function()
        --  vim.o.timeoutlen = 500
        -- end
    },
    { "mg979/vim-visual-multi" },
    { "catppuccin/nvim",       name = "catppuccin" },
    {
        'Exafunction/codeium.vim',
        event = 'BufEnter',
        config = function()
            vim.keymap.set('i', '<C-Tab>', function() return vim.fn['codeium#Accept']() end,
                { expr = true, silent = true })
        end
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            -- options
        },
    },
    { 'projekt0n/github-nvim-theme' },
    { "mfussenegger/nvim-jdtls" },
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
-- require 'lspconfig'.kotlin_language_server.setup {}

local dap = require('dap')
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/home/misman/Downloads/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
    },
    {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
    },
}

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
