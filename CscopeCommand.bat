
rm -rf cscope.*
rm -rf tags

ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
cscope -Rb


