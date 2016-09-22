" Save files if I forget to edit them as root and I don't have permission to save.
cnoremap w!! w !sudo tee > /dev/null %
