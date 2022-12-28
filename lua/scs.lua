local M = {}

M.opts = {
  theme = 'github-dark',
  tabWidth = 2,
  tmp_file = '/tmp/scs.png',
}

M.defaultShotOpts = {
  buffer = false,
  clipboard = true,
}

local mergeTables = function(t1, t2)
  if (t2 == nil) then return t1 end

  for k, v in pairs(t2) do
    t1[k] = v
  end

  return t1
end

M.setup = function(opts)
  -- merge options
  M.opts = mergeTables(M.opts, opts)
end

local getVisualSelection = function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')

  -- not sure if this is necessary, line('.') seems to work in cmd line and visual mode
  if first == last then
    first = vim.fn.line("'<")
    last = vim.fn.line("'>")
  end



  -- make sure we support select from bottom to top as well
  return { first = math.min(first,last), last = math.max(first,last) }
end

M.screenshot = function(shot_opts)
  local opts = mergeTables(M.defaultShotOpts, shot_opts)

  -- Choose between entire buffer or visual selection
  local vSelect = opts.buffer
      and { first = 1, last = vim.api.nvim_buf_line_count(0) }
      or getVisualSelection()

  local content = vim.api.nvim_buf_get_lines(0, vSelect.first - 1, vSelect.last, false)

  local curl = require('plenary.curl')
  local res = curl.get('https://sourcecodeshots.com/api/image', {
    query = {
      code = table.concat(content, "\n"),
      language = vim.bo.filetype,
      theme = M.opts.theme,
      tabWidth = M.opts.tabWidth
    },
    output = M.opts.tmp_file
  })

  -- weird way to exit to normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'x', true)


  if (opts.clipboard) then
    -- if (vim.fn.has('macunix')) then
    -- There should be a better way for this, but I'm not finding it
    os.execute("xclip -sel clip -t image/png " .. M.opts.tmp_file)
  end
end

return M
