# MiniCC
This is a minimal integration of Claude Code (CC) for Vim. It's only some simple communication between Vim/Claude via tmux. Obviously then, this only works when you are using CC and Vim in tmux panes.

Fittingly, this plugin is also made by Claude Code :)

## Installation

### vim-plug
```vim
Plug 'nonrice/minicc'
```

## Finding Claude 

By default the plugin auto-detects the Claude pane by looking for a pane whose current command contains `claude` (case-insensitive). To pin a specific pane manually:

```vim
let g:minicc_pane = '%3'
```

## Commands

### Sending prompts

| Command | Description |
|---|---|
| `:MiniCC <text>` | Send `<text>` as a prompt |
| `:MiniCCRef` | Type a `@/path:line` reference for the current line or selected range (no Enter) |
| `:MiniCCRefPrompt <text>` | Send current line/range reference + `<text>` as a prompt |

Ref commands auto-save the current buffer before sending.

### Buffer management

| Command | Description |
|---|---|
| `:MiniCCReload` | Reload all file buffers from disk. Aborts if any buffer has unsaved changes. |
| `:MiniCCCaptureRefs` | Reloads buffers, then adds the changes since the most recent prompt to quickfix |

### Pane control

| Command | Description |
|---|---|
| `:MiniCCTarget` | Echo which tmux pane is being used |

## Keybinding example
 
```vim
nnoremap <leader>cc :MiniCC<space>
nnoremap <leader>cp :MiniCCRefPrompt<space>
vnoremap <leader>cp :MiniCCRefPrompt<space>
nnoremap <leader>cr :MiniCCCaptureRefs<CR>
```
