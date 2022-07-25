-- Shorthand
local o = vim.opt

o.colorcolumn = { '81', '121' }
-- Spaces instead of tabs
o.expandtab = true
o.guifont = 'NotoSansMono NF'
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

-- FIXME: Remove for >0.7.2
--        72877bb17d70362f91a60b31bf0244dbf8ed58ae
-- Use filetype.lua
vim.g.do_filetype_lua = 1
-- Disable filetype.vim
vim.g.did_load_filetypes = 0
vim.filetype.add({
    extension = {
        jsonnet = 'jsonnet',
        libsonnet = 'jsonnet',
    },
    filename = {
        ['asoundrc'] = 'alsaconf',
        ['dir_colors'] = 'dircolors',
        ['gitconfig'] = 'gitconfig',
        ['xprofile'] = 'sh',
        ['.xprofile'] = 'sh',
    }
})

-- Install packer
local is_bootstrap = false
if vim.api.nvim_get_runtime_file('lua/packer.lua', false)[1] == nil then
    is_bootstrap = true
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.api.nvim_command('packadd packer.nvim')
end

require('packer').startup({function(use)
use { 'wbthomason/packer.nvim',
    opt = true,
}
-- LSP
use { 'neovim/nvim-lspconfig',
    requires = {
        'williamboman/nvim-lsp-installer',
    },
    -- FIXME: figure out delayed loading of LSP
    -- event = 'BufRead',
    config = function()
        -- XXX: Must come before lspconfig
        require('nvim-lsp-installer').setup({
            automatic_installation = true,
        })

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
use { 'nvim-treesitter/nvim-treesitter',
    event = 'BufEnter',
    config = function()
        -- Treesitter grammers not bundled with nvim-treesitter
        local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
        parser_config.elvish = {
            install_info = {
                url = "~/Workspaces/elvish/tree-sitter-elvish",
                branch = 'main',
                files = { 'src/parser.c' },
                generate_requires_npm = false,
                requires_generate_from_grammer = true,
            },
        }
        parser_config.jsonnet = {
            install_info = {
                url = 'https://github.com/sourcegraph/tree-sitter-jsonnet',
                branch = 'main',
                files = { 'src/parser.c', 'src/scanner.c' },
            },
        }
        parser_config.meson = {
            install_info = {
                url = 'https://github.com/bearcove/tree-sitter-meson',
                branch = 'main',
                files = { 'src/parser.c' },
            },
        }
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
use { 'nvim-treesitter/nvim-treesitter-context',
    after = {
        'nvim-treesitter'
    },
    event = 'BufEnter',
    -- FIXME:
    -- config = function()
    --     require('treesitter-context').setup({
    --         enable = true
    --     })
    -- end,
}
use { 'nvim-treesitter/nvim-treesitter-textobjects',
    after = {
        'nvim-treesitter',
    },
    event = 'BufEnter',
}
-- Completetions
use { 'hrsh7th/nvim-cmp',
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
                { name = 'path' },
                { name = 'buffer' },
            }
        })
    end,
    event = 'InsertEnter *',
}
-- Snippet Engine and Snippet Expansion
-- use {
--     'L3MON4D3/LuaSnip',
--     requires = { 'saadparwaiz1/cmp_luasnip' }
-- }
-- Formatting
use 'mhartington/formatter.nvim'
use 'gpanders/editorconfig.nvim'
-- Theme
use { 'chlorm/vim-colors-truecolor',
    config = function()
        local ok, _ = pcall(vim.api.nvim_command, 'colorscheme truecolor')
        -- Fallback
        if not ok then
            vim.api.nvim_command('colorscheme default')
        end
    end,
}
use { 'kyazdani42/nvim-web-devicons',
    -- event = 'VimEnter',
    config = function()
        require('nvim-web-devicons').setup({})
    end,
}
-- Languages (Non-Treesitter)
-- use 'chlorm/vim-syntax-elvish'
-- Restore buffer scroll/cursor position when reopening a file.
use 'farmergreg/vim-lastplace'
-- Git
use { 'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    event = 'BufEnter',
    config = function()
        require('gitsigns').setup()
    end,
}
-- Comments
use { 'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'BufEnter',
}
-- Comment visual regions w/ "gc"
use { 'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup({})
    end,
    event = 'BufEnter',
}
-- UI
use { 'kyazdani42/nvim-tree.lua',
    requires = {
        'kyazdani42/nvim-web-devicons',
    },
    config = function()
        require('nvim-tree').setup({})
    end,
}
use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    requires = {
        'kyazdani42/nvim-web-devicons',
    },
    event = 'VimEnter',
    config = function()
        require('bufferline').setup({})
    end,
}
use { 'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto',
            }
        })
    end,
}
use { 'lukas-reineke/indent-blankline.nvim',
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
end,
config = {
    max_jobs = 16,
},
})

-- Source and re-compile packer when init.lua is saved.
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'init.lua',
    group = packer_group,
    -- Reload config changes before PackerCompile
    command = 'luafile <afile>'
})
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'init.lua',
    group = packer_group,
    command = 'source <afile> | PackerCompile'
})

-- When quitting automatically close nvim-tree window.
vim.api.nvim_create_autocmd('BufEnter', {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1
                and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
            vim.api.nvim_command('quit')
        end
    end
})
