local intToBool = { [0]=false, [1]=true }
local isWindows = intToBool[vim.fn.has('win32')]
local isUnix = intToBool[vim.fn.has('unix')]
-- TODO: look for local file or environment variable to toggle
local isMinimal = false

vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = { '81', '121' }
vim.opt.cursorline = true
-- Spaces instead of tabs
vim.opt.expandtab = true
vim.opt.fileencoding = 'utf-8'
vim.opt.guifont = 'NotoSansMono NF'
vim.opt.iskeyword:append('-')
-- Faster scrolling
vim.opt.lazyredraw = true
-- Show listchars
vim.opt.list = true
vim.opt.listchars = {
    tab = '→ ',
    eol = '↲',
    nbsp = '␣',
    trail = '•',
    extends = '⟩',
    precedes = '⟨',
    space = '⋅',
}
vim.opt.mouse = 'a'
-- Line numbers
vim.opt.number = true
-- Keep cursor vertically centered
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.showbreak = '↪'
vim.opt.sidescrolloff = 8
-- Prevent UI from shifting when signcolumn loads
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
-- Auto indent new lines
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
-- Max columns for syntax highlighting
-- NOTE: Will break highlighting for any lines after a line that exceeds
--       the limit.
vim.opt.synmaxcol = 240
-- 1 tab == X spaces
vim.opt.tabstop = 4
-- Set terminal title
vim.opt.title = true
-- Save undo history
vim.opt.undofile = true
--o.writebackup = false

-- Disable some builtin plugins to improve load times
--g.loaded_gzip = 1
--g.loaded_zip = 1
--g.loaded_zipPlugin = 1
--g.loaded_tar = 1
--g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

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
    local install_path =
        vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.api.nvim_command('packadd packer.nvim')
end

require('packer').startup({function(use)
use {
    'lewis6991/impatient.nvim',
     config = function()
         require('impatient')
     end,
}
use 'wbthomason/packer.nvim'
use 'nvim-lua/plenary.nvim'
use { 'antoinemadec/FixCursorHold.nvim',
    config = function()
        vim.g.cursorhold_updatetime = 100
    end,
}
use { 'williamboman/mason.nvim',
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('mason').setup()
    end,
}
use { 'williamboman/mason-lspconfig.nvim',
    after = {
        'mason.nvim',
    },
    requires = {
        'williamboman/mason.nvim',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('mason-lspconfig').setup()
    end,
}
use { 'WhoIsSethDaniel/mason-tool-installer.nvim',
    after = {
        'mason.nvim',
    },
    requires = {
        'williamboman/mason.nvim',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        local ensureInstalled = {
            -- Ansible
            'ansible-language-server',
            -- AWK
            'awk-language-server',
            -- C(++)
            'clangd',
            -- CMake
            'cmake-language-server',
            -- CSS
            --'css-lsp',
            --'cssmodules-language-server',
            -- Docker
            'dockerfile-language-server',
            --Go
            'gopls',
            -- HTML
            'html-lsp',
            -- Java
            'jdtls',
            -- Json
            'json-lsp',
            -- Jsonnet
            'jsonnet-language-server',
            -- Lua
            'lua-language-server',
            -- Nickel
            --'nickel-lang-lsp',
            -- Nix
            'rnix-lsp',
            -- Perl
            'perlnavigator',
            -- Python
            'pyright',
            -- Rust
            'rust-analyzer',
            -- Saltstack
            --'salt-lsp',
            -- Shell
            'bash-language-server',
            'shellcheck',
            'shfmt',
            -- TOML
            'taplo',
            -- Typescript
            'typescript-language-server',
            -- Viml
            'vim-language-server',
            -- Yaml
            'yaml-language-server',
        }

        --if isUnix then
        --    -- TODO:
        --end

        if isWindows then
            -- Powershell
            table.insert(ensureInstalled, 'powershell-editor-services')
        end

        require('mason-tool-installer').setup({
            auto_update = false,
            run_on_start = true,
            start_delay = 5000,
            ensure_installed = ensureInstalled,
        })
    end,
}
-- LSP
use { 'neovim/nvim-lspconfig',
    after = {
        'mason-lspconfig.nvim',
    },
    requires = {
        'williamboman/mason-lspconfig',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        local onAttach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
        end

        local defaults = {
            on_attach = onAttach,
        }

        local lspconfig = require('lspconfig')
        -- Bash
        lspconfig.bashls.setup(defaults)
        -- C(++)
        lspconfig.clangd.setup(defaults)
        -- Cmake
        lspconfig.cmake.setup(defaults)
        -- Go
        lspconfig.gopls.setup(defaults)
        -- HTML
        lspconfig.html.setup(defaults)
        -- Java
        lspconfig.jdtls.setup(defaults)
        -- Json
        lspconfig.jsonls.setup(defaults)
        -- Jsonnet
        lspconfig.jsonnet_ls.setup(defaults)
        -- Lua
        lspconfig.sumneko_lua.setup {
            on_attach = onAttach,
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
        -- Nix
        lspconfig.rnix.setup(defaults)
        -- Powershell
        -- TODO:
        --lspconfig.powershell_es.setup(defaults)
        -- Python
        lspconfig.pyright.setup(defaults)
        -- SQL
        -- TODO
        --lspconfig.sqls.setup(defaults)
        lspconfig.tsserver.setup(defaults)
        -- Rust
        lspconfig.rust_analyzer.setup {
            on_attach = onAttach,
            -- Server-specific settings
            settings = {
                ["rust-analyzer"] = {}
            },
        }
        -- TOML
        lspconfig.taplo.setup(defaults)
        -- Viml
        lspconfig.vimls.setup(defaults)
    end,
}
-- LSP missing features
use { 'jose-elias-alvarez/null-ls.nvim',
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        local nullLs = require('null-ls')

        local jsonnetfmt = {
            method = nullLs.methods.FORMATTING,
            filetypes = { "jsonnet" },
            generator = nullLs.generator({
                command = "jsonnetfmt",
                args = { "-" },
                to_stdin = true,
            }),
        }
        nullLs.register(jsonnetfmt)

        nullLs.setup({
            sources = {
                -- Formatters
                nullLs.builtins.formatting.clang_format,
                nullLs.builtins.formatting.cmake_format,
                nullLs.builtins.formatting.gofmt,
                nullLs.builtins.formatting.jq,
                nullLs.builtins.formatting.nixpkgs_fmt,
                nullLs.builtins.formatting.prettier,
                nullLs.builtins.formatting.rustfmt,
                nullLs.builtins.formatting.shfmt,
                nullLs.builtins.formatting.stylua,
                nullLs.builtins.formatting.yapf,
                -- Linters
                --nullLs.builtins.diagnostics.buf,  -- proto
                --nullLs.builtins.diagnostics.checkmate,  -- make
                nullLs.builtins.diagnostics.chktex,
                --nullLs.builtins.diagnostics.cppcheck,
                --nullLs.builtins.diagnostics.deadnix,
                --nullLs.builtins.diagnostics.editorconfig-checker,
                --nullLs.builtins.diagnostics.gitlint,
                nullLs.builtins.diagnostics.markdownlint,
                --nullLs.builtins.diagnostics.mypy,
                --nullLs.builtins.diagnostics.protoc-gen-lint,
                --nullLs.builtins.diagnostics.protolint,
                nullLs.builtins.diagnostics.yamllint,
            },
        })
    end,
}
use { 'lvimuser/lsp-inlayhints.nvim',
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('lsp-inlayhints').setup()
    end,
}
use { 'folke/which-key.nvim',
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('which-key').setup()
    end,
}
-- Treesitter
use { 'nvim-treesitter/nvim-treesitter',
    event = 'BufWinEnter',
    run = ':TSUpdate',
    config = function()
        -- Treesitter grammers not bundled with nvim-treesitter
        local parser_config =
            require('nvim-treesitter.parsers').get_parser_configs()
        --parser_config.elvish = {
        --    install_info = {
        --        url = "~/Workspaces/elvish/tree-sitter-elvish",
        --        branch = 'main',
        --        files = { 'src/parser.c' },
        --        generate_requires_npm = false,
        --        requires_generate_from_grammer = true,
        --    },
        --}
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
                'jsonc',
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
                additional_vim_regex_highlighting = isMinimal,
            },
            indent = {
                enable = true,
            },
            context_commentstring = {
                enable = true,
            }
        })
    end,
}
use { 'nvim-treesitter/nvim-treesitter-context',
    after = {
        'nvim-treesitter'
    },
    requires = {
        'nvim-treesitter/nvim-treesitter',
    },
    disable = isMinimal,
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
    requires = {
        'nvim-treesitter/nvim-treesitter'
    },
    disable = isMinimal,
    event = 'BufEnter',
}
-- Completetions
use { 'hrsh7th/nvim-cmp',
    requires = {
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp', event = 'InsertEnter' },
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', event = 'InsertEnter' },
        { 'hrsh7th/cmp-path', after ='nvim-cmp', event = 'InsertEnter' },
        --{ 'hrsh7th/cmp-cmdline', after = 'nvim-cmp', event = 'InsertEnter' },
    },
    disable = isMinimal,
    event = 'InsertEnter',
    config = function()
        require('cmp').setup({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'path' },
                { name = 'buffer' },
            }
        })
    end,
}
-- Snippet Engine and Snippet Expansion
-- use {
--     'L3MON4D3/LuaSnip',
--     requires = { 'saadparwaiz1/cmp_luasnip' }
-- }
use { 'gpanders/editorconfig.nvim',
    event = 'BufWinEnter',
}
-- Theme
use { 'chlorm/vim-colors-truecolor',
    event = 'BufWinEnter',
    config = function()
        local ok, _ = pcall(vim.api.nvim_command, 'colorscheme truecolor')
        -- Fallback
        if not ok then
            vim.api.nvim_command('colorscheme default')
        end
    end,
}
use { 'kyazdani42/nvim-web-devicons',
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('nvim-web-devicons').setup({})
    end,
}
-- Languages (Non-Treesitter)
use 'chlorm/vim-syntax-elvish'
-- Restore buffer scroll/cursor position when reopening a file.
use { 'farmergreg/vim-lastplace',
    event = 'BufWinEnter',
}
-- Git
use { 'lewis6991/gitsigns.nvim',
    after = {
        'plenary.nvim',
    },
    requires = {
        'nvim-lua/plenary.nvim',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('gitsigns').setup({})
    end,
}
use { 'sindrets/diffview.nvim',
    after = {
        'plenary.nvim',
    },
    requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
    },
    disable = isMinimal,
    -- FIXME: load on command instead
    event = 'VimEnter',
    config = function()
        require("diffview").setup({
            -- see configuration in
            -- https://github.com/sindrets/diffview.nvim#configuration
        })
    end,
}
-- Comments
use { 'JoosepAlviste/nvim-ts-context-commentstring',
    after = {
        'nvim-treesitter',
    },
    requires = {
        'nvim-treesitter/nvim-treesitter',
    },
    disable = isMinimal,
    event = 'VimEnter',
}
-- Comment visual regions w/ "gc"
use { 'numToStr/Comment.nvim',
    event = 'VimEnter',
    config = function()
        require('Comment').setup({
            padding = false,
        })
    end,
}
-- UI
use { 'kyazdani42/nvim-tree.lua',
    requires = {
        'kyazdani42/nvim-web-devicons',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('nvim-tree').setup({
            open_on_setup = true,
            open_on_setup_file = false,
        })
    end,
}
use { 'akinsho/bufferline.nvim',
    tag = "v2.*",
    requires = {
        'kyazdani42/nvim-web-devicons',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('bufferline').setup({
            options = {
                always_show_bufferline = false,
                show_close_icon = false,
                show_tab_indicators = true,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    }
                },
            },
        })
    end,
}
use { 'nvim-lualine/lualine.nvim',
    requires = {
        'arkav/lualine-lsp-progress',
        'kyazdani42/nvim-web-devicons',
    },
    disable = isMinimal,
    event = 'VimEnter',
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto',
            },
            sections = {
                lualine_x = { 'lsp_progress' },
                lualine_y = {'encoding', 'fileformat', 'filetype'},
            },
        })
    end,
}
use { 'petertriho/nvim-scrollbar',
    event = 'WinScrolled',
    config = function()
        require('scrollbar').setup({
            set_highlights = false,
        })
    end,
}
-- Indent guides
use { 'lukas-reineke/indent-blankline.nvim',
    event = 'VimEnter',
    config = function()
        require('indent_blankline').setup({
            show_current_context = true,
        })
    end,
}
-- Fuzzy Finder (files, lsp, etc)
use { 'nvim-telescope/telescope.nvim',
    after = {
        'plenary.nvim',
    },
    requires = {
        'nvim-lua/plenary.nvim',
    },
    disable = isMinimal,
    event = 'VimEnter',
}
use { 'nvim-telescope/telescope-fzf-native.nvim',
    disable = isMinimal,
    event = 'VimEnter',
    run = [[
        cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        && cmake --build build --config Release \
        && cmake --install build --prefix build
    ]],
    cond = vim.fn.executable 'cmake' == 1
}

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
    pattern = '*/nvim/init.lua',
    group = packer_group,
    -- Reload config changes before PackerCompile
    command = 'luafile <afile>'
})
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*/nvim/init.lua',
    group = packer_group,
    command = 'source <afile> | PackerSync'
})

-- When quitting automatically close nvim-tree window.
if not isMinimal then
vim.api.nvim_create_autocmd('BufEnter', {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1
                and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
            vim.api.nvim_command('quit')
        end
    end
})
end

-- Language specific settings
local per_language_settings_group =
    vim.api.nvim_create_augroup('PerLanguageSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = per_language_settings_group,
    pattern = 'nix',
    command = 'setlocal tabstop=2 shiftwidth=2',
})
