:set number
:set nowrap
:set paste
:set tags=tags;/

syntax on
filetype plugin on
call pathogen#infect()
"colorscheme solarized
colorscheme twilight
set ts=4

" This assumes that ghc is in your path, if it is not, or you
" wish to use a specific version of ghc, then please change
" the ghc below to a full path to the correct one
au BufEnter *.hs compiler ghc

" For this section both of these should be set to your
" browser and ghc of choice, I used the following
" two vim lines to get those paths:
" :r!which google-chrome
" :r!whigh ghc
let g:haddock_browser = "/usr/bin/chromium"
let g:ghc = "/usr/bin/ghc"
noremap <C-l> :nohl<CR> 

" ghc-mod show type"
noremap <C-t> :GhcModType<Cr> 
"highlight LineNr term=bold cterm=NONE ctermfg=Black ctermbg=DarkGray gui=NONE guifg=DarkGrey guibg   =NONE
highlight Normal ctermbg=233
highlight Visual ctermbg=237
hi Search ctermbg=238

highlight LineNr ctermfg=241 ctermbg=232
highlight Pmenu ctermfg=241 ctermbg=233
highlight PmenuSel ctermfg=246 ctermbg=237

highlight Normal ctermbg=234


