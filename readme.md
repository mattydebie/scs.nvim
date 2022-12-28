# Source Code Shots .nvim
Simple integration of sourcecodeshots.com into neovim.

**not nearly finished** but is working for linux with xclip (or without copy).


## Installation
```bash
use 'mattydebie/scs.nvim'

require'scs'.setup {
  theme = 'github-dark',
  tabWidth = 2,
  tmp_file = '/tmp/scs.png',
}
```

## To take a screenshot
```
:lua require'scs'.screenshot()
```

The screenshot function takes two optional arguments.
```
{
  buffer = false,   // take a screenshot of the entire buffer
  clipboard = true, // copy the resulting image to clipbard
}
```
