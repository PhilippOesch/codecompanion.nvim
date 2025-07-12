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

T["Brave adapter"]["should format results correctly"] = function()
  local data = {
    web = {
      results = {
        { title = "Title 1", url = "https://example.com/1", description = "Content 1" },
        { title = "Title 2", url = "https://example.com/2", description = "Content 2" },
      },
    },
  }

  local expected = {
    "**Title: Title 1**\nURL: https://example.com/1\nContent: Content 1\n\n",
    "**Title: Title 2**\nURL: https://example.com/2\nContent: Content 2\n\n",
  }

  local res = adapter.methods.tools.web_search.output(adapter, data)
  h.eq(res, expected)
end

T["Brave adapter"]["should handle missing fields"] = function()
  local data = {
    web = {
      results = {
        { url = "https://example.com/1", description = "Content 1" },
        { title = "Title 2", description = "Content 2" },
        { title = "Title 3", url = "https://example.com/3" },
      },
    },
  }

  local expected = {
    "**Title: **\nURL: https://example.com/1\nContent: Content 1\n\n",
    "**Title: Title 2**\nURL: \nContent: Content 2\n\n",
    "**Title: Title 3**\nURL: https://example.com/3\nContent: \n\n",
  }

  local res = adapter.methods.tools.web_search.output(adapter, data)
  h.eq(res, expected)
end

return T
