vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError",
    { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
    { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
    { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
    { text = "", texthl = "DiagnosticSignHint" })
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

local renderer = require "neo-tree.ui.renderer"

-- Expand a node and load filesystem info if needed.
local function open_dir(state, dir_node)
    local fs = require "neo-tree.sources.filesystem"
    fs.toggle_directory(state, dir_node, nil, true, false)
end

-- Expand a node and all its children, optionally stopping at max_depth.
local function recursive_open(state, node, max_depth)
    local max_depth_reached = 1
    local stack = { node }
    while next(stack) ~= nil do
        node = table.remove(stack)
        if node.type == "directory" and not node:is_expanded() then
            open_dir(state, node)
        end

        local depth = node:get_depth()
        max_depth_reached = math.max(depth, max_depth_reached)

        if not max_depth or depth < max_depth - 1 then
            local children = state.tree:get_nodes(node:get_id())
            for _, v in ipairs(children) do
                table.insert(stack, v)
            end
        end
    end

    return max_depth_reached
end

--- Open the fold under the cursor, recursing if count is given.
local function neotree_zo(state, open_all)
    local node = state.tree:get_node()

    if open_all then
        recursive_open(state, node)
    else
        recursive_open(state, node, node:get_depth() + vim.v.count1)
    end

    renderer.redraw(state)
end

--- Recursively open the current folder and all folders it contains.
local function neotree_zO(state)
    neotree_zo(state, true)
end

-- The nodes inside the root folder are depth 2.
local MIN_DEPTH = 2

--- Close the node and its parents, optionally stopping at max_depth.
local function recursive_close(state, node, max_depth)
    if max_depth == nil or max_depth <= MIN_DEPTH then
        max_depth = MIN_DEPTH
    end

    local last = node
    while node and node:get_depth() >= max_depth do
        if node:has_children() and node:is_expanded() then
            node:collapse()
        end
        last = node
        node = state.tree:get_node(node:get_parent_id())
    end

    return last
end

--- Close a folder, or a number of folders equal to count.
local function neotree_zc(state, close_all)
    local node = state.tree:get_node()
    if not node then
        return
    end

    local max_depth
    if not close_all then
        max_depth = node:get_depth() - vim.v.count1
        if node:has_children() and node:is_expanded() then
            max_depth = max_depth + 1
        end
    end

    local last = recursive_close(state, node, max_depth)
    renderer.redraw(state)
    renderer.focus_node(state, last:get_id())
end

-- Close all containing folders back to the top level.
local function neotree_zC(state)
    neotree_zc(state, true)
end

--- Open a closed folder or close an open one, with an optional count.
local function neotree_za(state, toggle_all)
    local node = state.tree:get_node()
    if not node then
        return
    end

    if node.type == "directory" and not node:is_expanded() then
        neotree_zo(state, toggle_all)
    else
        neotree_zc(state, toggle_all)
    end
end

--- Recursively close an open folder or recursively open a closed folder.
local function neotree_zA(state)
    neotree_za(state, true)
end

--- Set depthlevel, analagous to foldlevel, for the neo-tree file tree.
local function set_depthlevel(state, depthlevel)
    if depthlevel < MIN_DEPTH then
        depthlevel = MIN_DEPTH
    end

    local stack = state.tree:get_nodes()
    while next(stack) ~= nil do
        local node = table.remove(stack)

        if node.type == "directory" then
            local should_be_open = depthlevel == nil or node:get_depth() < depthlevel
            if should_be_open and not node:is_expanded() then
                open_dir(state, node)
            elseif not should_be_open and node:is_expanded() then
                node:collapse()
            end
        end

        local children = state.tree:get_nodes(node:get_id())
        for _, v in ipairs(children) do
            table.insert(stack, v)
        end
    end

    vim.b.neotree_depthlevel = depthlevel
end

--- Refresh the tree UI after a change of depthlevel.
-- @bool stay Keep the current node revealed and selected
local function redraw_after_depthlevel_change(state, stay)
    local node = state.tree:get_node()

    if stay then
        require("neo-tree.ui.renderer").expand_to_node(state.tree, node)
    else
        -- Find the closest parent that is still visible.
        local parent = state.tree:get_node(node:get_parent_id())
        while not parent:is_expanded() and parent:get_depth() > 1 do
            node = parent
            parent = state.tree:get_node(node:get_parent_id())
        end
    end

    renderer.redraw(state)
    renderer.focus_node(state, node:get_id())
end

--- Update all open/closed folders by depthlevel, then reveal current node.
local function neotree_zx(state)
    set_depthlevel(state, vim.b.neotree_depthlevel or MIN_DEPTH)
    redraw_after_depthlevel_change(state, true)
end

--- Update all open/closed folders by depthlevel.
local function neotree_zX(state)
    set_depthlevel(state, vim.b.neotree_depthlevel or MIN_DEPTH)
    redraw_after_depthlevel_change(state, false)
end

-- Collapse more folders: decrease depthlevel by 1 or count.
local function neotree_zm(state)
    local depthlevel = vim.b.neotree_depthlevel or MIN_DEPTH
    set_depthlevel(state, depthlevel - vim.v.count1)
    redraw_after_depthlevel_change(state, false)
end

-- Collapse all folders. Set depthlevel to MIN_DEPTH.
local function neotree_zM(state)
    set_depthlevel(state, MIN_DEPTH)
    redraw_after_depthlevel_change(state, false)
end

-- Expand more folders: increase depthlevel by 1 or count.
local function neotree_zr(state)
    local depthlevel = vim.b.neotree_depthlevel or MIN_DEPTH
    set_depthlevel(state, depthlevel + vim.v.count1)
    redraw_after_depthlevel_change(state, false)
end

-- Expand all folders. Set depthlevel to the deepest node level.
local function neotree_zR(state)
    local top_level_nodes = state.tree:get_nodes()

    local max_depth = 1
    for _, node in ipairs(top_level_nodes) do
        max_depth = math.max(max_depth, recursive_open(state, node))
    end

    vim.b.neotree_depthlevel = max_depth
    redraw_after_depthlevel_change(state, false)
end

require("neo-tree").setup({
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "diagnostics",
        -- ...and any additional source
    },
    -- These are the defaults
    diagnostics = {
        bind_to_cwd = true,
        diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
        -- "position" means diagnostic items are sorted strictly by their positions.
        -- May also be a function.
        follow_behavior = { -- Behavior when `follow_current_file` is true
            always_focus_file = false, -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file.
            expand_followed = true, -- Ensure the node of the followed file is expanded
            collapse_others = true, -- Ensure other nodes are collapsed
        },
        follow_current_file = true,
        group_dirs_and_files = true, -- when true, empty folders and files will be grouped together
        group_empty_dirs = true, -- when true, empty directories will be grouped together
        show_unloaded = true, -- show diagnostics from unloaded buffers
    },
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
        indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            default = "*",
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
        },
        git_status = {
            symbols = {
                -- Change type
                added     = "✚",
                deleted   = "✖",
                modified  = "",
                renamed   = "",
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "",
                staged    = "",
                conflict  = "",
            }
        },
    },
    window = {
        position = "left",
        width = 40,
        mappings = {
            --     ["<2-LeftMouse>"] = "open",
            ["l"] = "open",
            ["h"] = "close_node",
            ["s"] = "split_with_window_picker",
            ["v"] = "vsplit_with_window_picker",
            ["<cr>"] = "open_with_window_picker",
            --     ["<bs>"] = "navigate_up",
            --     ["."] = "set_root",
            --     -- ["H"] = "toggle_hidden",
            --     ["R"] = "refresh",
            --     ["/"] = "fuzzy_finder",
            --     ["f"] = "filter_on_submit",
            --     ["<c-x>"] = "clear_filter",
            --     ["a"] = "add",
            --     ["d"] = "delete",
            --     ["r"] = "rename",
            --     ["y"] = "copy_to_clipboard",
            --     ["x"] = "cut_to_clipboard",
            --     ["p"] = "paste_from_clipboard",
            --     -- ["c"] = "copy", -- takes text input for destination
            --     -- ["m"] = "move", -- takes text input for destination
            --     ["q"] = "close_window",
        }
    },
    nesting_rules = {},
    filesystem = {
        filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            force_visible_in_empty_folder = true,
            show_hidden_count = true,
            hide_by_name = {
                ".DS_Store",
                "thumbs.db"
                --"node_modules"
            },
            never_show = { -- remains hidden even if visible is toggled to true
                --".DS_Store",
                --"thumbs.db"
            },
        },
        follow_current_file = false, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
            mappings = {
                ["z"] = "none",

                ["zo"] = neotree_zo,
                ["zO"] = neotree_zO,
                ["zc"] = neotree_zc,
                ["zC"] = neotree_zC,
                ["za"] = neotree_za,
                ["zA"] = neotree_zA,
                ["zx"] = neotree_zx,
                ["zX"] = neotree_zX,
                ["zm"] = neotree_zm,
                ["zM"] = neotree_zM,
                ["zr"] = neotree_zr,
                ["zR"] = neotree_zR,
            }
        }
    },
    buffers = {
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
            }
        },
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"]  = "git_add_all",
                ["S"]  = "git_add_all",
                ["U"]  = "git_unstage_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gs"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
            }
        }
    }
})
