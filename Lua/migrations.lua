local schema = require("lapis.db.schema")
local types = schema.types

return {
  [1] = function()
    schema.create_table("categories", {
      { "id", types.integer },
      { "name", types.text },
      "PRIMARY KEY (id)"
    })
  end,
  [2] = function()
    schema.create_table("items", {
      { "id", types.integer },
      { "name", types.text },
      { "category_id", types.integer },
      "PRIMARY KEY (id)"
    })
  end
}