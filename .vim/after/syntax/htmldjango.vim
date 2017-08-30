unlet b:current_syntax
syn include @HTML $VIMRUNTIME/syntax/htmldjango.vim
syn region htmlTemplate start=+<script [^>]*type *=[^>]*text/\(template\|html\)[^>]*>+
\                       end=+</script>+me=s-1 keepend
\                       contains=@HTML,htmlScriptTag,@htmlPreproc
