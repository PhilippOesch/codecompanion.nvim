local h = require("tests.helpers")

local adapter

local new_set = MiniTest.new_set
T = new_set()

T["Brave adapter"] = new_set({
  hooks = {
    pre_case = function()
      adapter = require("codecompanion.adapters.brave")
      adapter.opts = {}
    end,
  },
})

return T
