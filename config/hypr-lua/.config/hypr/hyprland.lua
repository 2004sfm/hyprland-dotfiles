-- Check if the environment wrapper (uwsm) is available in the system
local uwsm_installed = os.execute("command -v uwsm >/dev/null 2>&1")
local is_uwsm = uwsm_installed == true or uwsm_installed == 0

-- Global execution prefix available to all modules
EXEC_PREFIX = is_uwsm and "uwsm app -- " or ""

-- require("modules.envs")
require("modules.monitors")
require("modules.autostart")
require("modules.appearance")
require("modules.layout")
require("modules.input")
require("modules.misc")
require("modules.windowrules")
require("modules.keybindings")
-- require("modules.permission")
