return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
    },
    init = function()
      vim.g.dbs = {
        ["RDBMS Course DB"] = "postgresql://tyagi:1234@localhost:5432/rdbms_course",
      }
    end,
  },
}
