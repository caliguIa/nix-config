require('git-conflict').setup()
local neogit = require('neogit')
neogit.setup({
    initial_branch_name = 'OUS-',
})
Util.map.nl('gg', neogit.open, 'Git')
