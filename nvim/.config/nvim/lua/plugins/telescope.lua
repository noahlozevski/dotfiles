local default_ignored_files = { 'node_modules', '.git/', '.venv' }

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { "tsakirist/telescope-lazy.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim" },
        { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
        local telescope = require('telescope')
        local lga_actions = require("telescope-live-grep-args.actions")

        telescope.setup({
            defaults = {
                layout_config = {
                    height = vim.o.lines,  -- maximally available lines
                    -- height = 20,
                    width = vim.o.columns, -- maximally available columns
                    prompt_position = "bottom",
                    -- preview_height = 0.6, -- 60% of available lines
                },

                -- -- emulates the ivy layout by default for telescope windows
                layout_strategy = 'flex',
                -- layout_config = {
                --     height = 20,
                -- },
                border = true,
                sorting_strategy = "ascending",
                path_display = {
                    "smart",
                    -- "truncate",
                },
                file_ignore_patterns = {},
                -- file_ignore_patterns = { ".git/" },
            },
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            pickers = {
                live_grep = {
                    file_ignore_patterns = {},
                    -- file_ignore_patterns = default_ignored_files,
                    additional_args = function(_)
                        return { "--hidden" }
                    end
                },
                -- live_grep_args = {
                --     file_ignore_patterns = default_ignored_files,
                -- },
                find_files = {
                    file_ignore_patterns = {},
                    -- file_ignore_patterns = default_ignored_files,
                    hidden = true,
                    additional_args = function(_)
                        return { "--hidden" }
                    end,
                }
            },
            extensions = {
                live_grep_args = {
                    auto_quoting = true, -- enable/disable auto-quoting
                    mappings = {         -- extend mappings
                        i = {
                            -- wraps current prompt in quotes
                            -- "foo"
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            -- search for file paths
                            -- "foo" --iglob **/bar/**
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            -- searchs for specific type
                            -- "foo" -tmd
                            ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t" }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-f>"] = lga_actions.to_fuzzy_refine,
                        },
                    },
                }
            }
        })

        require("telescope").load_extension("live_grep_args")
        local builtin = require('telescope.builtin')
        -- local extensions = telescope.extensions

        -- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        -- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        -- Search workspace for text string
        -- vim.keymap.set('n', '<leader>ps', function()
        -- 	builtin.grep_string({ search = vim.fn.input(string.format("Search workspace (root: %s) > ", vim.fn.getcwd())) });
        -- end)

        --  local path_display = function(opts, path)
        --     local tail = require("telescope.utils").path_tail(path)
        --     return string.format("%s (%s)", tail, path)
        -- end
        --
        -- local find_files = function ()
        --     builtin.find_files({
        --         path_display = path_display
        --     })
        -- end
        --

        local lga = require("telescope").extensions.live_grep_args;
        function search_all_files()
            builtin.live_grep({
                hidden = true,
                no_ignore = true,
                no_ignore_parent = true,
                file_ignore_patterns = {}
            })
            -- lga.live_grep_args({
            --     hidden = true,
            --     no_ignore = true,
            --     no_ignore_parent = true,
            --     file_ignore_patterns = {}
            -- })
        end

        function find_all_files()
            builtin.find_files({
                hidden = true,
                no_ignore = true,
                no_ignore_parent = true,
                file_ignore_patterns = {},
            })
        end

        -- find all ( filtered ) files
        vim.keymap.set('n', '<C-p>', function()
            builtin.find_files({
                hidden = true,
                -- no_ignore = true,
                -- no_ignore_parent = true,
                file_ignore_patterns = default_ignored_files,
            })
        end, { silent = true })
        -- find all files
        vim.keymap.set('n', '<leader>faf', find_all_files, { noremap = true, silent = true })
        -- vim.keymap.set('n', '<C-p>', function() builtin.find_files({ path_display = path_display }) end, { silent = true })

        -- find all git files
        vim.keymap.set('n', '<leader>fg', function() builtin.git_files({ show_untracked = true }) end, { silent = true })

        -- this version of live grep allows to pass args
        -- vim.keymap.set('n', '<leader>fl', extensions.live_grep_args.live_grep_args, { silent = true })
        -- search all (filtered) files
        vim.keymap.set('n', '<leader>fl', function()
            lga.live_grep_args({
                -- no_ignore = true,
                -- no_ignore_parent = true,
                file_ignore_patterns = default_ignored_files,
            })
        end, { silent = true })
        -- search all files
        vim.keymap.set('n', '<leader>fal', search_all_files, { silent = true })

        vim.keymap.set('n', '<leader>fb', builtin.buffers, { silent = true })
        -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { silent = true })
        vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>ff', '<cmd>Telescope<CR>', { noremap = true, silent = true })
        -- vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
        -- vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
        -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        -- vim.keymap.set('n', '<leader>fs', function()
        --     builtin.grep_string({ search = vim.fn.input(string.format("Search workspace (root: %s) > ", vim.fn.getcwd())) });
        -- end)
        -- then load the extension
    end
}
