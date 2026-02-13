

vim.defer_fn(function()
  local pid = vim.fn.getpid()
  local socket = '/tmp/nvim-' .. pid .. '.socket'
  vim.fn.serverstart(socket)
end, 0)

local function fix_menu()
    local choices = {"spaces", "quotes", "both"}
    vim.ui.select(choices, {prompt = "fix"}, function(choice)
        if not choice then return end
        if choice == "spaces" or choice == "both" then
            vim.cmd("call CleanupWhitespace()")
        end
        if choice == "quotes" or choice == "both" then
            vim.cmd([[:%s/'\([^']*\)'/"\1"/g]])
        end
    end)
end

vim.keymap.set("n", "fix", fix_menu)

--[[

TODO keybindings for

vim.lsp.buf
.definition()
.declaration()
.implementation()
.type_definition()
.references()
.signature_help()
.rename()
.code_action()

vim.diagnostic
.open_float()
.goto_prev(), _next()

<C-x><C-o> for completion


vim.api.nvim_create_autocmd({"BufEnter"},
    {
        pattern = {"*.rs"},
        callback = function(ev)
            print(vim.fs.dirname(vim.fs.find({'Cargo.toml'}, {upward = true})[1]))
            vim.lsp.start({
                name = 'rust-analyzer',
                cmd = {'rust-analyzer'},
                root_dir = vim.fs.dirname(vim.fs.find({'Cargo.toml'}, {upward = true})[1]),
            })

            vim.keymap.set('n', '<leader><leader>', '<cmd>lua vim.lsp.buf.hover()<return>')
        end
    })

require('lsp_lines').setup()

vim.diagnostic.config({
    virtual_text = false,
})
]]--

