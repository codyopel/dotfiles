-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- LSP
    use {
        'williamboman/nvim-lsp-installer',
        requires = {
            'neovim/nvim-lsp-config',
        },
        config = function()
            require('nvim-lsp-installer').setup {
                automatic_installation = true,
            }
        end,
    }
    use {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.cmake.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            lspconfig.html.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            -- Java
            -- TODO: jdtls
            --lspconfig.jdtls.setup {}
            lspconfig.jsonls.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            lspconfig.jsonnet_ls.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            lspconfig.sumneko_lua.setup {
                on_attach = on_attach,
                flags = lsp_flags,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {'vim'}
                        },
                        runtime = {
                            version = 'LuaJIT',
                        },
                        telemetry = {
                            enable = false,
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file('', true),
                        },
                    }
                }
            }
            lspconfig.rnix.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            -- TODO:
            --luaconfig.powershell_es.setup {}
            lspconfig.pyright.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            -- TODO
            --luaconfig.sqls.setup {}
            lspconfig.tsserver.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            lspconfig.rust_analyzer.setup {
                on_attach = on_attach,
                flags = lsp_flags,
                -- Server-specific settings
                settings = {
                    ["rust-analyzer"] = {}
                },
            }
            -- TOML
            lspconfig.taplo.setup {
                on_attach = on_attach,
                flags = lsp_flags,
            }
            -- FIXME:
            -- luaconfig.vimls.setup {
            --     on_attach = on_attach,
            --     flags = lsp_flags,
            -- }
        end,
    }
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            -- Treesitter grammers not bundled with nvim-treesitter
            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.elvish = {
                install_info = {
                    url = "~/Workspaces/elvish/tree-sitter-elvish",
                    branch = "main",
                    files = {"src/parser.c"},
                    generate_requires_npm = false,
                    requires_generate_from_grammer = true,
                },
            }
            parser_config.jsonnet = {
                install_info = {
                    url = "https://github.com/sourcegraph/tree-sitter-jsonnet",
                    branch = "main",
                    files = {"src/parser.c", "src/scanner.c"},
                },
            }
            vim.cmd 'autocmd BufRead,BufNewFile *.jsonnet,*.libsonnet set filetype=jsonnet'
            parser_config.meson = {
                install_info = {
                    url = "https://github.com/bearcove/tree-sitter-meson",
                    branch = "main",
                    files = {"src/parser.c"},
                },
            }
            vim.cmd 'autocmd BufRead,BufNewFile *meson.build set filetype=meson'
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'bash',
                    'c',
                    'cmake',
                    'comment',
                    'cpp',
                    'css',
                    'dart',
                    'devicetree',
                    'dockerfile',
                    'elvish',
                    'glsl',
                    'go',
                    'gomod',
                    'haskell',
                    'hcl',
                    'help',
                    'html',
                    'http',
                    'java',
                    'javascript',
                    'json',
                    --'jsonc',
                    'jsonnet',
                    'latex',
                    'lua',
                    'make',
                    'markdown',
                    'meson',
                    'nix',
                    'perl',
                    'python',
                    'query',  -- Treesitter
                    'regex',
                    'rust',
                    'sql',
                    'toml',
                    'tsx',
                    'typescript',
                    'vim',
                    'wgsl',
                    'yaml',
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                context_commentstring = {
                    enable = true
                }
            })
        end,
        run = ':TSUpdate',
    }
    use {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require('treesitter-context').setup({
                enable = true
            })
        end,
    }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- Completetions
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after ='nvim-cmp' },
            { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        },
        config = function()
            require('cmp').setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                }
            })
        end,
        event = 'InsertEnter *',
    }
    -- Formatting
    use 'mhartington/formatter.nvim'
    use 'gpanders/editorconfig.nvim'
    -- Theme
    use {
        'chlorm/vim-colors-truecolor',
        config = function()
            local ok, _ = pcall(vim.cmd, 'colorscheme truecolor')
            -- Fallback
            if not ok then
                vim.cmd 'colorscheme default'
            end
        end,
    }
    -- Languages (Non-Treesitter)
    use 'chlorm/vim-syntax-elvish'
    -- Restore buffer scroll/cursor position when reopening a file.
    use 'farmergreg/vim-lastplace'
    -- Git
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end,
    }
    -- Comments
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    -- Comment visual regions w/ "gc"
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({})
        end,
        event = 'BufEnter',
    }
    --use 'ms-jpq/chadtree', {
    --    branch = 'chad',
    --    cond = vim.fn.executable 'python' == 1
    --    run = 'python -m chadtree deps',
    --}
    -- Snippet Engine and Snippet Expansion
    -- use {
    --     'L3MON4D3/LuaSnip',
    --     requires = { 'saadparwaiz1/cmp_luasnip' }
    -- }
    use {
        'akinsho/bufferline.nvim',
        tag = "v2.*",
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require('bufferline').setup({})
        end,
    }
    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                }
            })
        end,
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            --require("indent_blankline").setup{}
        end,
    }
    -- Fuzzy Finder (files, lsp, etc)
    -- use {
    --     'nvim-telescope/telescope.nvim',
    --     requires = { 'nvim-lua/plenary.nvim' }
    -- }
    --use {
    --    'nvim-telescope/telescope-fzf-native.nvim',
    --    run = 'make',
    --    cond = vim.fn.executable "make" == 1
    --}

    if is_bootstrap then
        require('packer').sync()
    end
end)

-- Source and re-compile packer when init.lua is saved.
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = 'init.lua',
})

-- Shorthand
local o = vim.opt

o.colorcolumn = { '81', '121' }
-- Spaces instead of tabs
o.expandtab = true
o.laststatus = 2
-- Faster scrolling
o.lazyredraw = true
-- Show listchars
o.list = true
o.listchars = {
    tab = '→ ',
    eol = '↲',
    nbsp = '␣',
    trail = '•',
    extends = '⟩',
    precedes = '⟨',
    --space = '•'
    space = '⋅',
}
o.mouse = 'a'
-- Line numbers
o.number = true
-- Show cursor coordinates
o.ruler = true
o.shiftwidth = 4
o.showbreak = '↪'
-- Auto indent new lines
o.smartindent = true
o.smarttab = true
o.swapfile = false
-- Max columns for syntax highlighting
-- NOTE: Will break highlighting for any lines after a line that exceeds
--       the limit.
o.synmaxcol = 240
-- 1 tab == X spaces
o.tabstop = 4
-- Set terminal title
o.title = true
-- Save undo history
o.undofile = true
