#!/data/data/com.termux/files/usr/bin/bash

# Termux Vim Setup Script
# Run: bash vim.sh

set -e

echo "Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "Installing Vim..."
pkg install vim -y

VIMRC="$HOME/.vimrc"
VIM_AUTOLOAD="$HOME/.vim/autoload"
PLUG_VIM="$VIM_AUTOLOAD/plug.vim"

# Create minimal .vimrc if it doesn't exist
if [[ ! -f "$VIMRC" ]]; then
    echo "Creating $VIMRC with basic settings..."
    cat > "$VIMRC" << 'EOF'
" Basic settings
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline
set backspace=indent,eol,start
set clipboard+=unnamedplus
syntax on
filetype plugin indent on

" Status line
set laststatus=2
set showcmd

" Use system clipboard (Termux specific)
if has('clipboard')
    set clipboard=unnamedplus
endif

" Better split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
EOF
    echo "Basic .vimrc created."
else
    echo "$VIMRC already exists. Skipping creation."
fi

# Ask about installing vim-plug
read -p "Install vim-plug plugin manager and recommended plugins? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing vim-plug..."
    curl -fLo "$PLUG_VIM" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo "Adding plugins to .vimrc..."
    # Append plug section to .vimrc if not already present
    if ! grep -q "call plug#begin" "$VIMRC"; then
        cat >> "$VIMRC" << 'EOF'

" vim-plug section
call plug#begin('~/.vim/plugged')

" Recommended plugins
Plug 'preservim/nerdtree'               " File explorer
Plug 'tpope/vim-fugitive'               " Git integration
Plug 'vim-airline/vim-airline'          " Status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'             " Easy commenting
Plug 'jiangmiao/auto-pairs'             " Auto bracket pairs
Plug 'morhetz/gruvbox'                  " Colorscheme

call plug#end()

" Colorscheme (gruvbox)
colorscheme gruvbox
set background=dark

" NERDTree shortcut
nnoremap <C-n> :NERDTreeToggle<CR>
EOF
        echo "Plugins added to .vimrc."
    else
        echo "vim-plug section already exists in .vimrc. Skipping."
    fi

    echo "Installing plugins (this may take a moment)..."
    vim -es -u "$VIMRC" -c "PlugInstall" -c "qa"
    echo "Plugins installed."
else
    echo "Skipping vim-plug installation."
fi

echo ""
echo "Vim setup completed!"
echo "To open Vim, type: vim"
echo "If you installed plugins, you can update them later with :PlugUpdate inside Vim."