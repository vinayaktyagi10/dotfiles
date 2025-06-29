-- ~/.config/nvim/lua/plugins/autopairs.lua
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'

    npairs.setup {
      check_ts = true,
      map_cr = true,
      enable_check_bracket_line = false,
    }

    -- Add spacing inside brackets like VS Code
    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }

    for _, bracket in pairs(brackets) do
      npairs.add_rules {
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
          :with_pair(function(opts)
            local next_char = opts.line:sub(opts.col, opts.col)
            return next_char == bracket[2]
          end)
          :with_move(function(opts)
            return opts.prev_char:match('.%' .. bracket[2]) ~= nil
          end)
          :use_key(bracket[2]),
      }
    end
  end,
}
