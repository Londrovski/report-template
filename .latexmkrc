# .latexmkrc — locks compiler to lualatex + biber. Overleaf reads this.
$pdf_mode = 4;            # lualatex
$bibtex_use = 2;          # always run biber
$biber = 'biber %O %B';
$out_dir = '.';
$clean_ext = 'aux bbl bcf blg fdb_latexmk fls log out run.xml synctex.gz toc lof lot wcsum';
