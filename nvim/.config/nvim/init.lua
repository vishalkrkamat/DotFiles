-- init.lua (or your main loader)
require("core.settings") -- 1️⃣ Set Vim options first
require("core.keymaps") -- 2️⃣ Core keymaps (basic, plugin-agnostic)
require("lazy_setup") -- 3️⃣ Plugin manager (loads plugins)
require("plugin_keymaps") -- 4️⃣ Plugin-specific keymaps (after plugins are loaded)
