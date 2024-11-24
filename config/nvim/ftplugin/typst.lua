local options = {
    tabstop = 2,
    shiftwidth = 2,
}

for k, v in pairs(options) do
    vim.opt_local[k] = v
end

local client = nil

local function start_typst_lsp()
    local buf = vim.api.nvim_get_current_buf()
    if not client then
        local config = {
            name = "tinymist",
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/tinymist",
            },
            autostart = true,
        }
        client = vim.lsp.start(config)
    elseif not vim.lsp.buf_is_attached(buf, client) then
        vim.lsp.buf_attach_client(buf, client)
    end
end

local function setup()
    -- CHANGE: make this run when not in git dir
    -- start_typst_lsp()
end

setup()
