colorscheme velvet

set-option global tabstop 2
set-option global indentwidth 2
set-option global scrolloff 1,3

# number lines
add-highlighter global/ number-lines -hlcursor

# highlight trailing whitespace
add-highlighter global/ regex \h+$ 0:Error

map global user y '<a-|>xclip -i -selection clipboard<ret>'
map global user p '<a-!>xclip -o<ret>'

source "%val{config}/bundle/kak-bundle/rc/kak-bundle.kak"
bundle-noload kak-bundle https://github.com/jdugan6240/kak-bundle

# IMPORTANT! make sure the first arg for the bundle is EXACTLY the same name as the plugin

bundle fzf.kak https://github.com/andreyorst/fzf.kak %{
	map global user f ": fzf-mode<ret>"
  # THE OPTIONS WONT SET!!!!!
  set-option global fzf_file_command 'fd'
  set-option global fzf_grep_command 'rg'
}

bundle kak-lsp https://github.com/kak-lsp/kak-lsp %{
	hook global WinSetOption filetype=(typescript) %{
    lsp-enable-window
	}
} %{
	cargo install --locked --force --path .
	mkdir -p ~/.dotfiles/.config/kak-lsp
	cp  -n kak-lsp.toml ~/.dotfiles/.config/kak-lsp
}

bundle kak-tree-sitter https://github.com/phaazon/kak-tree-sitter %{
	eval %sh{ kak-tree-sitter -dsk --session $kak_session }
} %{
	cargo install --locked --force --path ./kak-tree-sitter
	cargo install --locked --force --path ./ktsctl
}

# TODO: SOMEHOW ADD SNIPPETS??????
# inspired by: https://kkga.me/notes/kakoune-snippets
define-command shitty-snippet -params 1 %sh{
	eval set -- "$kak_opt_filetype"
	if [ -d "$HOME/.dotfiles/.config/kak/snippets/$kak_opt_filetype" ]; then
		if [ -e "$HOME/.dotfiles/.config/kak/snippets/$kak_opt_filetype/$1" ]; then
			printf "%s\n" 'execute-keys "|cat ~/.dotfiles/.config/kak/snippets/%opt{filetype}/%arg{1}<ret>s\$\d<ret>"'
    else
    	printf "%s" "echo snippet $1 isnt in the lang dir dumbass"
		fi
	else
		printf "%s" "echo you dont have a $kak_opt_filetype directory in your snippets folder dumbass"
	fi
} -docstring "poor man's snippets"

# lint/format config

### typescript
hook global BufSetOption filetype=typescript %{
	set-option buffer formatcmd "prettierd %val{buffile}"
}

hook global WinSetOption filetype=typescript %{
  set-option window lintcmd 'run() { cat "$1" | eslint_d -f unix --stdin --stdin-filename "$kak_buffile";} && run'
}
