# MiniCC
This is a minimal integration of Claude Code (CC) for Vim. It's only some simple communication between Vim/Claude via tmux. Obviously then, this only works when you are using CC and Vim in tmux panes.

Fittingly, this plugin is also made by Claude Code :)

## Installation

### vim-plug
```vim
Plug 'nonrice/minicc'
```

## Finding Claude 

By default the plugin auto-detects the Claude pane by looking for a pane whose current command matches `claude`. To pin a specific pane manually:

```vim
let g:minicc_pane = '%3'
```

## Commands

### Sending prompts

| Command | Description |
|---|---|
| `:MiniCC <text>` | Send `<text>` as a prompt |
| `:MiniCCLine` | Reference the current file and cursor line in the prompt |
| `:MiniCCRange` | Reference the current file and selected line range in the prompt |
| `:MiniCCSmart` | `:MiniCCLine` if no line selection, `:MiniCCRange` otherwise |
| `:MiniCCLinePrompt <text>` | Send current line reference + `<text>` as a prompt |
| `:MiniCCRangePrompt <text>` | Send range reference + `<text>` as a prompt |
| `:MiniCCSmartPrompt <text>` | It's obvious |

Also, line and range commands auto-save the current buffer before sending.

### Buffer management

| Command | Description |
|---|---|
| `:MiniCCReload` | Reload all file buffers from disk. Aborts if any buffer has unsaved changes. |
| `:MiniCCCaptureRefs` | Reloads buffers, then adds the changes since the most recent prompt to quickfix |

### Pane control

| Command | Description |
|---|---|
| `:MiniCCInterrupt` | Send `Ctrl-C` to the Claude pane |
| `:MiniCCTarget` | Echo which tmux pane is being used |

## Keybinding example
 
```vim
nnoremap <leader>cc :MiniCC<space>
nnoremap <leader>cp :MiniCCSmartPrompt<space>
vnoremap <leader>cp :MiniCCSmartPrompt<space>
nnoremap <leader>cr :MiniCCCaptureRefs<CR>
nnoremap <leader>ci :MiniCCInterrupt<CR>
```
