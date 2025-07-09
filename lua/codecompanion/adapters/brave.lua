local log = require("codecompanion.utils.log")

---@class CodeCompanion.Adapter
return {
  name = "brave",
  formatted_name = "brave",
  roles = {
    llm = "assistant",
    user = "user",
  },
  opts = {},
  url = "https://api.search.brave.com/res/v1/web/search",
  env = {
    api_key = "BRAVE_API_KEY",
  },
  headers = {
    ["Content-Type"] = "application/json",
    ["Accept-Encoding:"] = "gzip",
    ["X-Subscription-Token"] = "${api_key}",
  },
  schema = {
    model = {
      default = "brave",
    },
  },
  handlers = {
    -- https://api-dashboard.search.brave.com/app/documentation/web-search/get-started
    -- TODO: Move this into a separate method if we implement other Brave endpoints
    set_query = function(adapter, data)
      if data.query == nil or data.query == "" then
        return log:error("Search query is required")
      end

      adapter.opts = adapter.opts or {}
      local query_params = {
        q = data.query,
        count = 10,
        result_filter = "web",
      }

      return query_params
    end,
  },
  methods = {
    tools = {
      web_search = {
        -- TODO: Implement

        -- ---Process the output from the web search tool
        -- ---@param self CodeCompanion.Adapter
        -- ---@param data table The data returned from the web search
        -- ---@return table
        -- output = function(self, data)
        --   if data.results == nil or #data.results == 0 then
        --     log:error("No results found")
        --     return {}
        --   end
        --
        --   local output = {}
        --   for _, result in ipairs(data.results) do
        --     local title = result.title or ""
        --     local url = result.url or ""
        --     local content = result.content or ""
        --     table.insert(output, string.format("**Title: %s**\nURL: %s\nContent: %s\n\n", title, url, content))
        --   end
        --
        --   return output
        -- end,
      },
    },
  },
}
