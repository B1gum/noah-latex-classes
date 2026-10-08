$pdf_mode = 4; # LuaLaTeX

# glossaries-extra writes .glo files; teach latexmk how to build .gls files.
add_cus_dep('glo', 'gls', 0, 'noah_makeglossaries');

sub noah_makeglossaries {
  return system("makeglossaries \"$_[0]\"");
}

$clean_ext .= ' acn acr alg glg glo gls ist xdy';
