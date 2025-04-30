-- plantuml file specific options

-- set up plantuml language server
vim.api.nvim_create_autocmd("FileType", {
    pattern = "plantuml",
    callback = function(args)
        -- set up lsp configuration
        local config = {
            name = "plantuml-lsp",
            cmd = {
                "/home/patrick/projects/plantuml-lsp/plantuml-lsp",
                -- "/home/patrick/.local/share/nvim/mason/bin/plantuml-lsp",
                -- "--stdlib-path=/home/patrick/Documents/plantuml-stdlib",
                "--stdlib-path=~/Documents/plantuml-stdlib",
                "--exec-path=plantuml", -- TODO: test this works with the java-jar syntax
                -- "--jar-path=/home/patrick/Downloads/plantuml-mit-1.2025.0.jar", -- TODO: test this works with the java-jar syntax
            },
            root_dir = vim.fs.root(args.buf, ".git")
                or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf)),
            autostart = true,
        }

        -- start lsp client
        vim.lsp.start(config)
    end,
})

local function display_messages(messages)
    vim.schedule(function()
        local concatenated_messages = table.concat(messages, "\n")
        vim.api.nvim_echo({ { concatenated_messages, "None" } }, true, {})
    end)
end

local function handle_job_output(filepath, err, return_val)
    local messages = {}
    if return_val == 0 then
        table.insert(messages, "Successfully compiled " .. filepath)
    else
        table.insert(
            messages,
            "Compilation failed with exit code: " .. return_val
        )
        if err and #err > 0 then
            table.insert(messages, "Error Trace:")
            for _, line in ipairs(err) do
                table.insert(messages, line)
            end
        end
    end
    display_messages(messages)
end

local function compile_plantuml(open_output)
    open_output = open_output == "true"
    local filename = vim.fn.expand("%:t")
    if not filename:match("%.puml$") then
        print("Current file is not a .puml file.")
        return
    end

    local filepath = vim.fn.expand("%:p")
    local relpath = vim.fn.fnamemodify(filepath, ":.")
    local output_path = filepath:gsub("%.puml$", ".png")
    local output_relpath = relpath:gsub("%.puml$", ".png")
    local err_output = {}

    display_messages({ "Compiling PlantUML diagram for " .. relpath .. "..." })
    -- TODO: turn this job code into a custom callable function somewhere since it is also used for the R and latex versions.
    require("plenary.job")
        :new({
            command = "plantuml",
            args = { filepath },
            on_stderr = function(_, data)
                table.insert(err_output, data)
            end,
            on_exit = function(_, return_val)
                handle_job_output(output_relpath, err_output, return_val)
                if open_output and return_val == 0 then
                    require("plenary.job")
                        :new({
                            command = "feh",
                            args = { output_path },
                            on_stderr = function(_, data)
                                table.insert(err_output, data)
                            end,
                        })
                        :start()
                end
            end,
        })
        :start()
end

local function compile_all_plantuml()
    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.fnamemodify(current_file, ":h")
    local puml_files = vim.fn.globpath(current_dir, "*.puml", false, true)

    if vim.tbl_isempty(puml_files) then
        print("No .puml files found in the directory.")
        return
    end

    for _, filepath in ipairs(puml_files) do
        local relpath = vim.fn.fnamemodify(filepath, ":.")
        local output_path = filepath:gsub("%.puml$", ".png")
        local err_output = {}

        display_messages({
            "Compiling PlantUML diagram for " .. relpath .. "...",
        })
        require("plenary.job")
            :new({
                command = "plantuml",
                args = { filepath },
                on_stderr = function(_, data)
                    table.insert(err_output, data)
                end,
                on_exit = function(_, return_val)
                    handle_job_output(output_path, err_output, return_val)
                end,
            })
            :start()
    end
end

local function open_plantuml_output()
    local filename = vim.fn.expand("%:t")
    if not filename:match("%.puml$") then
        print("Current file is not a .puml file.")
        return
    end

    local filepath = vim.fn.expand("%:p")
    local output_path = filepath:gsub("%.puml$", ".png")

    if vim.fn.filereadable(output_path) == 1 then
        require("plenary.job")
            :new({
                command = "feh",
                args = { output_path },
                on_stderr = function(_, data)
                    print("Error opening file: " .. data)
                end,
            })
            :start()
    else
        print("Output file does not exist.")
    end
end

local function open_all_plantuml_output()
    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.fnamemodify(current_file, ":h")
    local png_files = vim.fn.globpath(current_dir, "*.png", false, true)

    if vim.tbl_isempty(png_files) then
        print("No .png files found in the directory.")
        return
    end

    local err_output = {}
    require("plenary.job")
        :new({
            command = "feh",
            args = png_files,
            on_stderr = function(_, data)
                table.insert(err_output, data)
            end,
        })
        :start()
end

local function setup()
    if vim.fn.exists(":PlantumlCompile") > 0 then
        return
    end

    vim.api.nvim_create_user_command("PlantumlCompile", function(opts)
        compile_plantuml(opts.args)
    end, {
        desc = "Compile current open plantuml file into a diagram",
        nargs = "?",
    })
    vim.api.nvim_create_user_command(
        "PlantumlCompileAll",
        compile_all_plantuml,
        {
            desc = "Compile all .puml files in the current directory into diagrams",
        }
    )

    vim.api.nvim_create_user_command(
        "PlantumlView",
        open_plantuml_output,
        { desc = "Open the compiled PlantUML diagram if it exists" }
    )
    vim.api.nvim_create_user_command(
        "PlantumlViewAll",
        open_all_plantuml_output,
        { desc = "Open all .png files in the current directory" }
    )

    vim.keymap.set("n", "<leader>cc", function()
        vim.cmd("PlantumlCompile")
    end, { desc = "[C]ompile [c]urrent PlantUML file" })

    vim.keymap.set("n", "<leader>cd", function()
        vim.cmd("PlantumlCompileAll")
    end, { desc = "[C]ompile all PlantUML files in [d]irectory" })

    vim.keymap.set("n", "<leader>co", function()
        vim.cmd("PlantumlCompile true")
    end, { desc = "[C]ompile and current PlantUML file and [o]pen output" })

    vim.keymap.set("n", "<leader>cv", function()
        vim.cmd("PlantumlView")
    end, { desc = "[V]iew [c]urrent PlantUML file output" })

    vim.keymap.set("n", "<leader>cb", function()
        vim.cmd("PlantumlViewAll")
    end, { desc = "View all PlantUML file outputs" })

    vim.cmd("doautocmd FileType plantuml")
end

setup()
