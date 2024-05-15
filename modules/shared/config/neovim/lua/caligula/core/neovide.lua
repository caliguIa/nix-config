if vim.g.neovide then
    local alpha = function()
        return string.format('%x', math.floor((255 * vim.g.transparency) or 0.8))
    end

    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_transparency = 0.0
    vim.g.transparency = 0.8
    vim.g.neovide_background_color = '#0f1117' .. alpha()
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5
    vim.g.neovide_show_border = false
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_refresh_rate = 120
    vim.g.neovide_fullscreen = true
    vim.g.neovide_remember_window_size = true
    vim.o.guifont = 'BerkeleyMono Nerd Font:h14'
end
