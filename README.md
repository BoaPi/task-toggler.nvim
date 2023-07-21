# task-toggler
Neovim plugin for check or uncheck tasks in markdown files. A Task is:
* `[ ]` - unchecked task
* `[x]` - checked task

## Features

* instead of using regex to find tasks, use treesitter
* multi-line check & un-check
* complete file check & un-check

## Requirements

* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* neovim >9.0.0 was tested, but should also run on previous versions

## Installation

### Packer

```lua
use {
  'BoaPi/task-toggler.nvim',
  requires = "nvim-treesitter",
  ft = "markdown"
}

```

### Lazy

```lua
{
  'BoaPi/task-toggler.nvim',
  config = true,
  dependencies = "nvim-treesitter",
  ft = "markdown"
}
```

## Notes

To be able to check & uncheck task in a **visual selection** (visual mode), it is neseccary to bind the command to a key combination,
e.g. `<leader>tc`, otherwise the check & uncheck is not working proberly. The reason is, that otherwise the visual mode will be quit before
and the start and end of the selected range is not correct.

## Commands

### Check Task
check the selected line or selected range of tasks.
```lua
-- example keeps visual selection active
"<leader>tc", "<CMD>TaskTogglerCheck<CR>"
```

```lua
-- example switches into normal mode afterwrads
"<leader>tc", "<CMD>TaskTogglerCheck<CR><Esc>"
```

To check all tasks in a file just use this command.
```lua
-- example switches into normal mode afterwrads
"<leader>ta", "<CMD>TaskTogglerCheckAll<CR>"
```


### Uncheck Task
check the selected line or selected range of tasks.
```lua
-- example keeps visual selection active
"<leader>tu", "<CMD>TaskTogglerUncheck<CR>"
```

```lua
-- example switches into normal mode afterwrads
"<leader>tu", "<CMD>TaskTogglerUncheck<CR><Esc>"
```

To uncheck all tasks in a file just use this command.
```lua  
-- example switches into normal mode afterwrads
"<leader>tc", "<CMD>TaskTogglerUncheckAll<CR>"
```
