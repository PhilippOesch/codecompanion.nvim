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

T["Brave adapter"]["should return properly formatted query with default options"] = function()
  local data = { query = "test query" }
  local query = adapter.handlers.set_query(adapter, data)

  h.eq(query.q, data.query)
  h.eq(query.count, 10)
  h.eq(query.result_filter, "web")
end

T["Brave adapter"]["should use adapter options if provided"] = function()
  adapter.opts = {
    count = 15,
    result_filter = "discussions",
  }

  local data = { query = "test query" }
  local query = adapter.handlers.set_query(adapter, data)

  h.eq(query.q, data.query)
  h.eq(query.count, 15)
  h.eq(query.result_filter, "discussions")
end

return T
