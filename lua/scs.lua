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

M.screenshot = function(shot_opts)
  local opts = mergeTables(M.defaultShotOpts, shot_opts)

  local vFirst = opts.buffer and 1 or vim.fn.line("'<")
  local vLast = opts.buffer
      and vim.api.nvim_buf_line_count(0)
      or vim.fn.line("'>")

  local content = vim.api.nvim_buf_get_lines(0, vFirst - 1, vLast, false)

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


  if (opts.clipboard) then
    -- if (vim.fn.has('macunix')) then
    -- There should be a better way for this, but I'm not finding it
    os.execute("xclip -sel clip -t image/png " .. M.opts.tmp_file)
 end
end

return M
