
vim.o.ignorecase = true
vim.o.smartcase = true

local function find_and_replace()
    vim.ui.input({ prompt = 'Find: ' }, function(find)
        if not find then return end
        vim.ui.input({ prompt = 'Replace: ' }, function(replace)
            if not replace then return end
            vim.cmd(string.format('%%s/%s/%s/g',
                vim.fn.escape(find, '/\\'),
                vim.fn.escape(replace, '/\\')))
        end)
    end)
end

vim.keymap.set("n", "far", find_and_replace)

vim.defer_fn(function()
    local pid = vim.fn.getpid()
    local socket = '/tmp/nvim-' .. pid .. '.socket'
    vim.fn.serverstart(socket)
end, 0)

local function fix_menu()
    local choices = {"spaces", "quotes", "all"}
    vim.ui.select(choices, {prompt = "fix"}, function(choice)
        if not choice then return end
        if choice == "spaces" or choice == "all" then
            vim.cmd("call CleanupWhitespace()")
        end
        if choice == "quotes" or choice == "all" then
            vim.cmd([[:%s/'\([^']*\)'/"\1"/g]])
        end
    end)
end

vim.keymap.set("n", "fix", fix_menu)

vim.paste = (function(overridden)
    return function(lines, phase)
        local is_2_spaced = false

        for _, line in ipairs(lines) do
            local space_count = #line:match("^%s*")
            if space_count > 0 and space_count % 4 ~= 0 and space_count % 2 == 0 then
                is_2_spaced = true
                break
            end
        end

        if is_2_spaced then
            for i, line in ipairs(lines) do
                lines[i] = line:gsub("^(%s*)", function(s)
                    return string.rep(" ", #s * 2)
                end)
            end
        end

        overridden(lines, phase)
    end
end)(vim.paste)

vim.filetype.add({
    extension = { cl = "chatlog" },
})

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")


require('hbac').setup({
    autoclose = true,
    threshold = 10,
})

require('telescope').setup({})

require('buffer_view')

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

