let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_mode='inv'  "enable all functions, which is equal to
let g:user_emmet_mode='a' 

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
