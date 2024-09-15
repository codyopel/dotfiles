local intToBool = { [0]=false, [1]=true }
local isWindows = intToBool[vim.fn.has('win32')]
local isUnix = intToBool[vim.fn.has('unix')]
function hasExe(exe)
    return intToBool[vim.fn.executable(exe)]
end
-- TODO: look for local file or environment variable to toggle
local isMinimal = false

-- FIXME: Remove this, conflicts with system clipboard in some cases where
--        you wouldn't want it to.
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = { '81', '121' }
vim.opt.cursorline = true
-- Spaces instead of tabs
vim.opt.expandtab = true
vim.opt.fileencoding = 'utf-8'
vim.opt.guifont = 'NotoSansM Nerd Font Mono'
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
vim.opt.wildmode = 'list:longest'
--o.writebackup = false

-- FIXME: Figure out leader character
vim.g.mapleader = ' '
--vim.keymap.set("n", "<leader>pv", vim.cmd.ex)

-- Disable some builtin plugins to improve load times
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

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

vim.filetype.add({
    extension = {
        jsonnet = 'jsonnet',
        libsonnet = 'jsonnet',
        tmpl = 'gotmpl',
    },
    filename = {
        ['asoundrc'] = 'alsaconf',
        ['private_dot_dir_colors'] = 'dircolors',
        ['gitconfig'] = 'gitconfig',
        ['htoprc'] = 'dosini',
        ['private_dot_minttyrc'] = 'dosini',
        ['mpd.conf'] = 'nginx',
        ['mpDris2.conf'] = 'dosini',
        ['mpv.conf'] = 'dosini',
        ['spectrwm.conf'] = 'dosini',
        ['private_dot_xprofile'] = 'sh',
        ['.xprofile'] = 'sh',
    },
    pattern = {
        ['.*git/config'] = 'gitconfig',
        ['.*ncmpcpp/config'] = 'dosini',
        ['.*ncmpcpp/config.generate'] = 'dosini',
        ['.*pipewire/.*.conf'] = 'nginx',
        ['.*systemd/user/.*.service'] = 'systemd',
        ['.*systemd/user/.*.service.generate'] = 'systemd',
        ['.*.toml.tmpl'] = 'toml',
    }
})

local plugins = {
'nvim-lua/plenary.nvim',
{
    'antoinemadec/FixCursorHold.nvim',
    config = function()
        vim.g.cursorhold_updatetime = 100
    end,
},
{
    'williamboman/mason.nvim',
    enabled = not isMinimal,
    config = function()
        require('mason').setup()
    end,
},
{
    'williamboman/mason-lspconfig.nvim',
    after = {
        'mason-tool-installer.nvim',
    },
    dependencies = {
        'williamboman/mason.nvim',
    },
    enabled = not isMinimal,
    config = function()
        require('mason-lspconfig').setup()
    end,
},
{
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
        'williamboman/mason.nvim',
    },
    enabled = not isMinimal,
    config = function()
        local ensureInstalled = {
            -- C(++)
            'clangd',
            -- CSS
            --'css-lsp',
            --'cssmodules-language-server',
             -- Java
            'jdtls',
            -- Lua
            'lua-language-server',
            -- Rust
            'rust-analyzer',
            -- Saltstack
            --'salt-lsp',
            -- Shell
            'shellcheck',
            'shfmt',
            -- TOML
            'taplo',
            -- Yaml
            'yamlfmt',
        }

        local function inst(pkg)
            table.insert(ensureInstalled, pkg)
        end

        if hasExe('cargo') then
            if isUnix then
                -- Nickel
                inst('nickel-lang-lsp')
                -- Nix
                inst('rnix-lsp')
            end
        end

        if hasExe('go') then
            -- Go
            inst('gopls')
            -- Jsonnet
            inst('jsonnet-language-server')
        end

        if hasExe('npm') then
            -- Ansible
            inst('ansible-language-server')
            -- AWK
            if isUnix then
                inst('awk-language-server')
            end
            -- BASH
            inst('bash-language-server')
            -- Docker
            inst('dockerfile-language-server')
            -- HTML
            inst('html-lsp')
            -- Json
            inst('json-lsp')
            -- Perl
            inst('perlnavigator')
            -- Python
            inst('pyright')
            -- Typescript
            inst('typescript-language-server')
            -- Viml
            inst('vim-language-server')
            -- Yaml
            inst('yaml-language-server')
        end

        if hasExe('python') then
            -- CMake
            inst('cmake-language-server')
            -- XML
            inst('xmlformatter')
        end

        if hasExe('pwsh') then
            -- Powershell
            inst('powershell-editor-services')
        end

        require('mason-tool-installer').setup({
            auto_update = false,
            run_on_start = true,
            start_delay = 5000,
            ensure_installed = ensureInstalled,
        })
    end,
},
-- LSP
{
    'lvimuser/lsp-inlayhints.nvim',
    enabled = not isMinimal,
    config = function()
        require('lsp-inlayhints').setup()
    end,
},
{
    'neovim/nvim-lspconfig',
    dependencies = {
        'lvimuser/lsp-inlayhints.nvim',
        'williamboman/mason-lspconfig',
    },
    enabled = not isMinimal,
    config = function()
        local signs = {
            Error = ' ',
            Warning = ' ',
            Hint = ' ',
            Information = ' '
        }

        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
        end

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
            vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)

            require('lsp-inlayhints').on_attach(client, bufnr, false)
        end

        local defaults = {
            on_attach = onAttach,
        }

        local lspConfig = require('lspconfig')
        -- Ansible
        lspConfig.ansiblels.setup(defaults)
        -- AWK
        lspConfig.awk_ls.setup(defaults)
        -- Bash
        lspConfig.bashls.setup(defaults)
        -- C(++)
        lspConfig.clangd.setup(defaults)
        -- Cmake
        lspConfig.cmake.setup(defaults)
        -- CSS
        lspConfig.cssls.setup(defaults)
        -- Docker
        lspConfig.dockerls.setup(defaults)
        -- Elvish
        --lspConfig.elvish.setup(defaults)
        -- Go
        lspConfig.gopls.setup(defaults)
        -- HTML
        lspConfig.html.setup(defaults)
        -- Java
        lspConfig.jdtls.setup(defaults)
        -- Json
        lspConfig.jsonls.setup(defaults)
        -- Jsonnet
        lspConfig.jsonnet_ls.setup(defaults)
        -- Lua
        lspConfig.lua_ls.setup {
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
                        checkThirdParty = false,
                    },
                }
            }
        }
        -- Nix
        lspConfig.rnix.setup(defaults)
        -- Perl
        lspConfig.perlls.setup(defaults)
        -- Powershell
        if isWindows then
            lspConfig.powershell_es.setup({
                bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services/',
            })
        end
        -- Python
        lspConfig.pyright.setup(defaults)
        -- SQL
        lspConfig.sqlls.setup(defaults)
        -- Rust
        lspConfig.rust_analyzer.setup {
            on_attach = onAttach,
            -- Server-specific settings
            settings = {
                ['rust-analyzer'] = {}
            },
        }
        -- Salt Stack
        lspConfig.salt_ls.setup(defaults)
        -- Tailwind CSS
        lspConfig.tailwindcss.setup(defaults)
        -- TOML
        lspConfig.taplo.setup(defaults)
        -- Typescript
        lspConfig.ts_ls.setup(defaults)
        -- Viml
        lspConfig.vimls.setup(defaults)
        -- YAML
        lspConfig.yamlls.setup(defaults)
        -- Zig
        lspConfig.zls.setup(defaults)
    end,
},
-- LSP missing features
{
    'jose-elias-alvarez/null-ls.nvim',
    enabled = not isMinimal,
    config = function()
        local nullLs = require('null-ls')

        local jsonnetfmt = {
            method = nullLs.methods.FORMATTING,
            filetypes = { 'jsonnet' },
            generator = nullLs.generator({
                command = 'jsonnetfmt',
                args = { '-' },
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
},
{
    'folke/which-key.nvim',
    enabled = not isMinimal,
    config = function()
        require('which-key').setup()
    end,
},
{
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        -- Treesitter grammers not bundled with nvim-treesitter
        local parserConfig =
            require('nvim-treesitter.parsers').get_parser_configs()
        --parserConfig.elvish = {
        --    install_info = {
        --        url = "~/Workspaces/elvish/tree-sitter-elvish",
        --        branch = 'main',
        --        files = { 'src/parser.c' },
        --        generate_requires_npm = false,
        --        requires_generate_from_grammer = true,
        --    },
        --}
        --parserConfig.jsonnet = {
        --    install_info = {
        --        url = 'https://github.com/sourcegraph/tree-sitter-jsonnet',
        --        branch = 'main',
        --        files = { 'src/parser.c', 'src/scanner.c' },
        --    },
        --}
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'awk',
                'bash',
                'c',
                --'c_sharp',
                'cmake',
                'comment',
                'commonlisp',
                'cpp',
                'css',
                'dart',
                'devicetree',
                'diff',
                'dockerfile',
                'elvish',
                'git_config',
                'git_rebase',
                'gitattributes',
                'gitcommit',
                'gitignore',
                'glsl',
                'go',
                'gomod',
                'gotmpl',
                'haskell',
                'hcl',
                'html',
                'http',
                'java',
                'javascript',
                'jq',
                'json',
                'jsonc',
                'jsonnet',
                'kconfig',
                'latex',
                'lua',
                'make',
                'markdown',
                'meson',
                'nasm',
                'nickel',
                'ninja',
                'nix',
                'perl',
                'php',
                'proto',
                'python',
                'query',  -- Treesitter
                'regex',
                --'ruby',
                'rust',
                'sql',
                'ssh_config',
                'svelte',
                'tmux',
                'toml',
                'tsx',
                'typescript',
                'vala',
                'vim',
                'vimdoc',
                'wgsl',
                'xml',
                'yaml',
                'zig',
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = isMinimal,
            },
            ignore_install = { },
            indent = {
                enable = true,
            },
            modules = { },
            sync_install = false,
            ts_context_commentstring = {
                enable = true,
            }
        })
    end,
},
{
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    enabled = not isMinimal,
    config = function()
        require('treesitter-context').setup({
            enable = true,
            max_lines = 10,
            min_window_height = 40,
            separator = nil,  -- '-'
        })
    end,
},
{
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
        'nvim-treesitter/nvim-treesitter'
    },
    enabled = not isMinimal,
    event = 'BufEnter',
},
{
    'Dronakurl/injectme.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    cmd = {
        "InjectmeToggle",
        "InjectmeSave",
        "InjectmeInfo" ,
        "InjectmeLeave"
    },
    config = function()
        require("injectme").setup({
            -- "all"/ "none" if all/no injections should be activated on startup
            --    When you use, lazy loading, call :InjectemeInfo to activate
            -- "standard", if no injections should be changed from standard settings in 
            --    the runtime directory, i.e. ~/.config/nvim/queries/<language>/injections.scm
            mode = "standard",
            -- after toggling an injection, all buffers are reloaded to reset treesitter
            -- you can set this to false, and avoid that the plugin asks you to save buffers 
            -- before changing an injection
            reload_all_buffers = true,
})
    end,
},
-- Completetions
{
    'hrsh7th/nvim-cmp',
    dependencies = {
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-path' },
        --{ 'hrsh7th/cmp-cmdline' },
    },
    enabled = not isMinimal,
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
},
-- Snippet Engine and Snippet Expansion
-- use {
--     'L3MON4D3/LuaSnip',
--     dependencies = { 'saadparwaiz1/cmp_luasnip' }
-- }
{
    'gpanders/editorconfig.nvim',
    event = 'BufWinEnter',
},
-- Theme
{
    'chlorm/vim-colors-truecolor',
    event = 'BufWinEnter',
    config = function()
        local ok, _ = pcall(vim.api.nvim_command, 'colorscheme truecolor')
        -- Fallback
        if not ok then
            vim.api.nvim_command('colorscheme default')
        end
    end,
},
{
    'kyazdani42/nvim-web-devicons',
    enabled = not isMinimal,
    config = function()
        require('nvim-web-devicons').setup({})
    end,
},
-- Restore buffer scroll/cursor position when reopening a file.
{
    'vladdoster/remember.nvim',
    lazy = false,
    config = function()
        require('remember').setup({})
    end,
},
-- Git
{
    'lewis6991/gitsigns.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    enabled = not isMinimal,
    config = function()
        require('gitsigns').setup({})
    end,
},
{
    'sindrets/diffview.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
    },
    enabled = not isMinimal,
    -- FIXME: load on command instead
    config = function()
        require('diffview').setup({
            -- see configuration in
            -- https://github.com/sindrets/diffview.nvim#configuration
        })
    end,
},
-- Comments
{
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    enabled = not isMinimal,
},
-- Comment visual regions w/ "gc"
{
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup({
            padding = false,
        })
    end,
},
-- UI
{
    'kyazdani42/nvim-tree.lua',
    dependencies = {
        'kyazdani42/nvim-web-devicons',
    },
    enabled = not isMinimal,
    config = function()
        --local function treeAttach(bufnr)
        --    api.config.mappings.default_on_attach(bufnr)
        --end
        --
        require('nvim-tree').setup({
            -- FIXME:
            --open_on_setup = true,
            --open_on_setup_file = false,
            --on_attach = treeAttach
        })
    end,
},
{
    'akinsho/bufferline.nvim',
    dependencies = {
        'kyazdani42/nvim-web-devicons',
    },
    enabled = not isMinimal,
    config = function()
        require('bufferline').setup({
            options = {
                always_show_bufferline = false,
                show_close_icon = false,
                show_tab_indicators = true,
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = 'File Explorer',
                        highlight = 'Directory',
                        text_align = 'left',
                    }
                },
            },
        })
    end,
},
{
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'arkav/lualine-lsp-progress',
        'kyazdani42/nvim-web-devicons',
    },
    enabled = not isMinimal,
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
},
{
    'petertriho/nvim-scrollbar',
    event = 'WinScrolled',
    config = function()
        require('scrollbar').setup({
            set_highlights = false,
        })
    end,
},
-- Indent guides
{
    'lukas-reineke/indent-blankline.nvim',
    event = 'VimEnter',
    config = function()
        require('ibl').setup({
            scope = {
                enabled = true,
            },
        })
    end,
},
-- Fuzzy Finder (files, lsp, etc)
{
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- FIXME: Breaks on windows
        --{
        --    'nvim-telescope/telescope-fzf-native.nvim',
        --    build = [[
        --        cmake -G Ninja -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        --        && cmake -G Ninja --build build --config Release \
        --        && cmake -G Ninja --install build --prefix build
        --    ]],
        --    cond = hasExe('cmake') and hasExe('ninja'),
        --    config = function()
        --        require('telescope').load_extension('fzf')
        --    end,
        --},
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end,
    enabled = not isMinimal,
},
}  -- End plugins

local lazyOpts = {
    defaults = {
        lazy = false,
    },
}

local lazyPath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazyPath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim',
        '--branch=stable',
        lazyPath,
    })
end
vim.opt.rtp:prepend(lazyPath)

require('lazy').setup(plugins, lazyOpts)

-- When quitting automatically close nvim-tree window.
--if not isMinimal then
--vim.api.nvim_create_autocmd('BufEnter', {
--    nested = true,
--    callback = function()
--        if #vim.api.nvim_list_wins() == 1
--                and vim.api.nvim_buf_get_name(0):match('NvimTree_') ~= nil then
--            vim.api.nvim_command('quit')
--        end
--    end,
--})
--end

-- Language specific settings
local per_language_settings_group =
    vim.api.nvim_create_augroup('PerLanguageSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = per_language_settings_group,
    pattern = 'nix',
    command = 'setlocal tabstop=2 shiftwidth=2',
})
