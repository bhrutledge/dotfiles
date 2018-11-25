" https://coderwall.com/p/vgk5-q/make-vim-play-nice-with-html-templates-inside-script-tags
" TODO: `unlet` and `syn include` break htmldjango.

" html.vim will exit if this is defined
" unlet b:current_syntax

" Convenience for collecting all of the html regions
" syn include @HTML $VIMRUNTIME/syntax/html.vim

" Using @htmlTop to get basic syntax highlighting until TODO above is fixed.
syn region htmlTemplate start=+<script [^>]*type *=[^>]*text/\(template\|html\)[^>]*>+
\                       end=+</script>+me=s-1 keepend
\                       contains=@htmlTop,htmlScriptTag,@htmlPreproc
