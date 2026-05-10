# minicc.vim

Minimal Vim integration for [Claude Code](https://claude.ai/code). Intended for a workflow where Vim and Claude Code run in separate tmux splits.

## Requirements

- tmux
- Claude Code running in a tmux pane

## Installation

```vim
" vim-plug
Plug '/path/to/minicc'
```

## Configuration

By default the plugin auto-detects the Claude pane by looking for a pane whose current command matches `claude`. To pin a specific pane manually:

```vim
let g:minicc_pane = '%3'  " tmux pane ID
```

## Commands

### Sending prompts

| Command | Description |
|---|---|
| `:MiniCC <text>` | Send `<text>` to Claude and press Enter |
| `:MiniCCLine` | Type `@/path:line` reference for the current line (no Enter) |
| `:MiniCCRange` | Type `@/path:line1-line2` reference for the selected range (no Enter) |
| `:MiniCCSmart` | `:MiniCCLine` if no selection, `:MiniCCRange` otherwise |
| `:MiniCCLinePrompt <text>` | Send current line reference + `<text>` and press Enter |
| `:MiniCCRangePrompt <text>` | Send range reference + `<text>` and press Enter |
| `:MiniCCSmartPrompt <text>` | Smart version of the above |

Line and range commands auto-save the current buffer before sending.

### Buffer management

| Command | Description |
|---|---|
| `:MiniCCReload` | Reload all file buffers from disk. Aborts if any buffer has unsaved changes. |
| `:MiniCCCaptureRefs` | Reload buffers, then parse Claude's pane output and populate the quickfix list with one entry per changed hunk. Only captures edits from the most recent prompt. |

### Pane control

| Command | Description |
|---|---|
| `:MiniCCInterrupt` | Send `Ctrl-C` to the Claude pane |
| `:MiniCCTarget` | Echo which tmux pane is being used |

## Suggested keybindings

```vim
nnoremap <leader>cc :MiniCC<space>
nnoremap <leader>cp :MiniCCSmartPrompt<space>
vnoremap <leader>cp :MiniCCSmartPrompt<space>
nnoremap <leader>cr :MiniCCCaptureRefs<CR>
nnoremap <leader>ci :MiniCCInterrupt<CR>
```
