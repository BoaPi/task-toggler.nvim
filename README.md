# task-toggler
Neovim plugin for check or uncheck tasks in markdown files.

## features

* instead of using regex to find tasks, use treesitter
* multi-line check & un-check
* complete file check & un-check

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
