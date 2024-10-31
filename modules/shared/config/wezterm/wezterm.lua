local utils = require "lua/utils"
local opts = require "lua/config"
local appearance = require "lua/appearance"
local keys = require "lua/keys"

local config = utils.merge_tables(opts, appearance, keys)

local colourScheme = require "lua/no-clown-fiesta"
colourScheme.apply_to_config(config)

return config
