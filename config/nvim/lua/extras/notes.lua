local M = {
    picker = {
        fzf = nil,
    },
}

---@param opts table?
function M.auto_rename(opts)
    -- TODO: rename based on note title
    -- - Probably use a cli tool
end

function M.insert_link()
    local mode = vim.fn.mode()
    if mode == "n" then
        local word = vim.fn.expand("<cword>")
        -- TODO: decide on link syntax (custom vs obsidian)
        vim.cmd("normal! ciW[[" .. word .. "]]")
    elseif mode == "v" then
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('c[[<C-r>"]]', true, false, true),
            "n",
            false
        )
    end
end

function M.follow_link()
    local line = vim.api.nvim_get_current_line()
    -- TODO: decide on link syntax (custom vs obsidian)
    local link = line:match("%[%[([^%)]+)%]%]")
    if not link then
        print("No valid link found under the cursor.")
        return
    end

    local search_pattern = vim.fn.shellescape(link)

    local cmd = "fd -t f -E '*.pdf' " .. search_pattern .. " ~/notes"
    local handle = io.popen(cmd)

    if not handle then
        print("Error running fd")
        return
    end

    local result = handle:read("*a")
    handle:close()

    local files = {}
    for l in result:gmatch("[^\r\n]+") do
        table.insert(files, l)
    end

    if #files == 0 then
        print("No matching files found for: " .. link)
    elseif #files == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
    else
        M.fzf.fzf_exec(files, {
            prompt = "Select file: ",
            cwd = "~/notes",
            previewer = "builtin",
            actions = {
                ["default"] = function(selected)
                    vim.cmd("edit " .. vim.fn.fnameescape(selected[1]))
                end,
            },
        })
    end
end

function M.browse_links()
    -- TODO: pull out the contents of the link, show only that in the picker
    -- (show preview of actual file contents)
    M.fzf.grep_project({ cwd = "~/notes", filter = "rg '\\[\\[.*\\]\\]'" })
end

---@param opts table?
function M.create_note_blueprinter(opts)
    opts = vim.tbl_deep_extend("force", {
        fname = "note.md",
        template = "note.md",
        path = "~/notes/inbox/",
    }, opts)

    local outFile = opts.path .. opts.fname

    local output = vim.fn.system(
        "blueprinter -v -i " .. opts.template .. " -o " .. outFile
    )
    if output:find("^Error") then
        print(outFile .. " already exists")
        vim.cmd("e " .. opts.path .. opts.fname)
        return
    end
    vim.cmd("e " .. output)
    -- TODO: add buffer autocmd to cause file rename on pre-save?
end

function M.create_daily_note()
    local date = os.date("%Y-%m-%d")
    local out_file = "~/notes/notes/daily/" .. date .. ".md"

    local output = vim.fn.system(
        "blueprinter -v -t daily -i daily.md -o "
            .. out_file
            .. " -id '\"Daily Note: "
            .. date
            .. "\"'"
    )
    if output:find("^Error") then
        print(out_file .. " already exists")
        vim.cmd("e " .. out_file)
        return
    end

    vim.cmd("e " .. output)
end

function M.create_file_blueprinter()
    M.fzf.files({
        prompt = "Select template: ",
        cwd = "~/dotfiles/templates",
        hidden = false,
        actions = {
            ["default"] = function(selected)
                local output = vim.fn.system(
                    "blueprinter -v -i "
                        .. vim.fn.shellescape(selected[1]:match("^[^\t]+"))
                )
                if output:find("^Error") then
                    print(vim.fn.trim(output))
                    output = selected[1]:match("^[^\t]+")
                    -- return
                end
                vim.cmd("edit " .. output)
            end,
        },
    })
end

---@param opts table?
function M.init(opts)
    M.fzf = require("fzf-lua")

    vim.keymap.set("n", "<leader>ns", function()
        M.browse_links()
    end, { desc = "Browse Links" })

    vim.keymap.set(
        { "n", "x" },
        "<leader>nl",
        M.insert_link,
        { desc = "Insert [N]ote [L]ink" }
    )

    vim.api.nvim_create_user_command(
        "Blueprinter",
        M.create_file_blueprinter,
        { desc = "Create file with Blueprinter" }
    )

    vim.api.nvim_create_user_command(
        "Note",
        M.create_note_blueprinter,
        { desc = "Create note with Blueprinter" }
    )

    vim.api.nvim_create_user_command(
        "DailyNote",
        M.create_daily_note,
        { desc = "Create daily note with Blueprinter" }
    )
end

M.init()

return M
