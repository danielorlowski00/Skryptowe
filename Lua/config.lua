local config = require("lapis.config")
config("development", {
  mysql = {
    host = "127.0.0.1",
    user = "root",
    password = "password",
    database = "lua_database"
  }
})