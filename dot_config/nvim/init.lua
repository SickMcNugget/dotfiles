-- Setup plugins, remaps and defaults
require("joren")
require("lazy-plugins")

-- Themes are currently:
-- - onedark
-- - tokyonight
local theme = "tokyonight"

pcall(require, "plugins.theme." .. theme)

vim.cmd.colorscheme(theme)
