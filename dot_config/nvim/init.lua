-- Setup plugins, remaps and defaults
require("joren")
require("lazy-plugins")

-- Themes are currently:
-- - onedark
local theme = "onedark"

pcall(require, "plugins.theme." .. theme)

vim.cmd.colorscheme(theme)
