local lapis = require("lapis")
local util = require("lapis.util")
local app = lapis.Application()
local db = require("lapis.db")
local Model = require("lapis.db.model").Model

local Categories = Model:extend("categories")
local Items = Model:extend("items")


app:get("/", function()
  return "Witaj w moim sklepie"
end)

app:get("/categories", function()
  return util.to_json(Categories:select())
end)

app:get("/items", function()
  return util.to_json(Items:select())
end)

app:get("/categories/", function(self)
  local category = Categories:find({id = self.params.id})
  if (category ~= nil)
  then
    return util.to_json(category)
  else
    return "Podana kategoria nie istnieje"
  end
end)

app:get("/items/", function(self)
  local item = Items:find({id = self.params.id})
  if (item ~= nil)
  then
    return util.to_json(item)
  else
    return "Podany przedmiot nie istnieje"
  end
end)

app:delete("/categories", function(self)
  local category = Categories:find({id = self.params.id})
  if (category ~= nil)
  then
    local item = Items:find({category_id = self.params.id})
    while (item ~= nil) do
      item:delete()
      item = Items:find({category_id = self.params.id})
    end
    category:delete()
    return "Kategoria została skasowana"
  else
    return "Podana kategoria nie istnieje"
  end
end)

app:delete("/items", function(self)
  local item = Items:find({id = self.params.id})
  if (item ~= nil)
  then
    item:delete()
    return "Przedmiot został skasowany"
  else
    return "Podany przedmiot nie istnieje"
  end
end)

app:post("/items", function(self)
  local category = Categories:find({ id = self.params.category_id })
  if (category ~= nil)
  then
    local item = Items:create({
      id = self.params.id,
      name = self.params.name,
      category_id = self.params.category_id
    })
    return util.to_json(item)
  else
    return "Nie istnieje kategoria do której miałby należeć przedmiot"
  end
end)

app:post("/categories", function(self)
  local category = Categories:create({
    id = self.params.id,
    name = self.params.name
  })
  return util.to_json(category)
end)

app:put("/categories", function(self)
  local category = Categories:find({ id = self.params.id })
  if (category ~= nil)
  then
    category:update({
      name = self.params.name
    })
    return util.to_json(category)
  else
    return "Podana kategoria nie istnieje"
  end
end)

app:put("/items", function(self)
  local item = Items:find({ id = self.params.id })
  local category = Categories:find({ id = self.params.category_id })
  if (item ~= nil and category ~= nil)
  then
    item:update({
      name = self.params.name,
      category_id = self.params.category_id
    })
    return "Dane przedmiotu zostały zaktualizowane pomyślnie"
  else
    return "Podany przedmiot bądź kategoria nie istnieje"
  end
end)

return app
