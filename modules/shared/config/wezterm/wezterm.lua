local utils = require "lua/utils"
local config = require "lua/config"
local appearance = require "lua/appearance"
local keys = require "lua/keys"
local colours = require "lua/colours"

return utils.merge_tables(config, appearance, keys, colours)
