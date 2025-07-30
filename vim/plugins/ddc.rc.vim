let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
let g:log_files_dir = expand('~/efm-langserver.log')
let g:lsp_settings_enable_suggestions = 1

call ddc#custom#patch_global(#{
        \   ui: 'pum',
        \   autoCompleteEvents: [
        \     'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged',
        \   ],
        \   cmdlineSources: {
        \     ':': ['cmdline', 'around']
        \   },
        \ })

nnoremap : <Cmd>call CommandlinePre()<CR>:

function! CommandlinePre() abort
    cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
    cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
    cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
    cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
    cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
    cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
    autocmd User DDCCmdlineLeave ++once call CommandlinePost()
    " Enable command line completion for the buffer
    call ddc#enable_cmdline_completion()
endfunction

function! CommandlinePost() abort
    silent! cunmap <Tab>
    silent! cunmap <S-Tab>
    silent! cunmap <C-n>
    silent! cunmap <C-p>
    silent! cunmap <C-y>
    silent! cunmap <C-e>
endfunction

call ddc#custom#patch_global('sources', ['vim-lsp', 'around', 'file'])

call ddc#custom#patch_global('sourceOptions', {
    \   '_': {
    \     'matchers': ['matcher_head'],
    \     'sorters': ['sorter_rank'],
    \   },
    \   'around': {
    \     'mark': 'A',
    \   },
    \   'vim-lsp': {
    \     'mark': '[LSP]',
    \     'matchers': ['matcher_head'],
    \     'sorters': ['sorter_rank'],
    \     'forceCompletionPattern': '\.\w*|:\w*|->\w*',
    \   },
    \   'file': {
    \     'mark': 'F',
    \     'isVolatile': v:true,
    \     'forceCompletionPattern': '\S/\S*',
    \   },
    \ })

call ddc#custom#patch_filetype(
    \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
    \   'file': {
    \     'forceCompletionPattern': '\S\/\S*',
    \   },
    \ },
    \ 'sourceParams': {
    \   'file': {
    \     'mode': 'unix',
    \   },
    \ }})

call ddc#enable()

inoremap <silent><expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#map#manual_complete()

inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

if executable('efm-langserver')
  augroup LspEFM
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'efm-langserver',
        \ 'cmd': {server_info->['efm-langserver', '-c='.$HOME.'/dotfiles/vim/efm-langserver/config.yaml']},
        \ 'whitelist': ['go', 'lua', 'typescript', 'typescriptreact', 'javascript'],
        \ })
  augroup END
endif

autocmd BufWritePre *.lua,*.ts,*.go call execute('LspDocumentFormat')
