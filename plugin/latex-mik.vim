" 
" File:    latex-mik.vim
" Purpose: LaTeX support (MikTeX) for GVIM on Win32-systems 
" Version: 0.7
" Author:  Volker Kiefel <volker dot kiefel at freenet dot de>
"
" Documentation of this script may be found in latex-mik.pdf, source of
" documentation: latex-mik.tex.
"
" For installation, please put this file (latex-mik.vim) into the vim 
" plugin-directory
"
" This script adds a menu for LaTeX-related functions for .tex, .bib-files
"
" Usage:
" To process multiple file LaTeX-projects, enter the project name (e.g.
" ``myproject'') at the prompt, if ``myproject.tex'' is the main file.
"
" Menu options address 
"
"   (pdf)latex
"   bibtex
"   makeindex
"   yap (dvi-viewer)
"   dvips
"   gsview32
"   tth
"
" Latex-mik supports entering commands, environments and BibTeX entries.
"
" This script is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
"
" V0.1: initial upload
" v0.2: unused code removed
" v0.3: BibTeX document type unpublished corrected
" v0.4: Documentation added
" v0.5: Documentation corrected
" v0.6: Environment definitions completed; the most important commands have
"       mapped to `,la' (LaTeXProject) `,vi' (ViewFile) etc.; documentation
"       updated
" v0.7: Problem fixed: after opening TeX-related files with the gvim `File 
"       Open...' dialog, the current working directory is now set 
"       automatically. This change requires that all edited files of a 
"       project are in the same directory.
"       Some environments added.
"

:function! Standard_map()
   :map! ä \"a
   :map! ö \"o
   :map! ü \"u
   :map! Ä \"A
   :map! Ö \"O
   :map! Ü \"U
   :map! ß {\ss}
   :set isk+=58,46
:endfunction

:function! GetProjName()
  let s:projektname = input("Enter project name [default current file]: ")
  if (s:projektname=="" || s:projektname==" ")
   let s:projektname = expand("%:t:r")
  endif
  echo " (".s:projektname.")"
:endfunction

:function! ExeYap()
  if exists("s:projektname") == 0
   call GetProjName()
   return
  endif
  let s:zlnr=line(".")
  let befehl="silent !yap -s ".s:zlnr.expand("%:t")." ".s:projektname.".dvi"
  execute(befehl)
:endfunction

:function! ExeLatex()
  if exists("s:projektname") == 0
    call GetProjName()
   return
  endif
  let befehl="silent !latex -src ".s:projektname
  execute(befehl)
:endfunction

:function! Exedvips()
  if exists("s:projektname") == 0
    call GetProjName()
   return
  endif
  let befehl="!dvips ".s:projektname
  execute(befehl)
:endfunction

:function! Exegsv()
  if exists("s:projektname") == 0
    call GetProjName()
   return
  endif
  let befehl="!gsview32 ".s:projektname.".ps"
  execute(befehl)
:endfunction

:function! ExePDFLaTeX()
  if exists("s:projektname") == 0
    call GetProjName()
   return
  endif
  let befehl="silent !pdflatex ".s:projektname
  execute(befehl)
:endfunction

:function! ExeBibtex()
  if exists("s:projektname") == 0
   call GetProjName()
   return
  endif
  let befehl="!bibtex ".s:projektname
  execute(befehl)
:endfunction

:function! Exetohtml()
  if exists("s:projektname") == 0
   call GetProjName()
   return
  endif
  let befehl="!tth ".s:projektname.".tex"
  execute(befehl)
:endfunction


:function! ExeMakeindex()
  if exists("s:projektname") == 0
   call GetProjName()
   return
  endif
  let befehl="!makeindex ".s:projektname
  execute(befehl)
:endfunction


:function! Remove_map()
   :call Standard_map()
   :unmap! ä
   :unmap! ö
   :unmap! ü
   :unmap! Ä
   :unmap! Ö
   :unmap! Ü
   :unmap! ß
   :set isk-=58,46
:endfunction

:function! German_map()
   :map! ä "a
   :map! ö "o
   :map! ü "u
   :map! Ä "A
   :map! Ö "O
   :map! Ü "U
   :map! ß "s
:endfunction

:function! Bibtex_map()
   :map! ä {\"a}
   :map! ö {\"o}
   :map! ü {\"u}
   :map! Ä {\"A}
   :map! Ö {\"O}
   :map! Ü {\"U}
   :map! ß {\ss}
:endfunction

:function! Deutsche_umschreibungen_map()
   :map! ä ae
   :map! Ä Ae
   :map! ö oe
   :map! Ö Oe
   :map! ü ue
   :map! Ü Ue
   :map! ß ss
:endfunction

:function! Empty_env()
 :let umgebung = input("Enter environment Name: ")
 :if strlen(umgebung) == 0
   :echo "Environment aborted"
   :return
 :elseif umgebung == "itemize" || umgebung == "enumerate" || umgebung == "citemize"
   :let ausgabe = "\\begin{".umgebung."}\n  \\item \n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "description" 
   :let ausgabe = "\\begin{".umgebung."}\n  \\item[] \n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "minipage"
   :let envoption = input("Enter minipage type for latex209 or latex2e [209, 2e]: ")
   :if envoption == "2e"
     :let ausgabe = "\\begin{".umgebung."}[][][]{}\n\n\\end{".umgebung."}"
   :else
     :let ausgabe = "\\begin{".umgebung."}[]{}\n\n\\end{".umgebung."}"
   :endif
   :put!=ausgabe
 :elseif umgebung == "tabular"
   :let ausgabe = "\\begin{".umgebung."}[]{}\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "columns"
   :let ausgabe = "\\begin{".umgebung."}[]\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "column" || umgebung == "block"
   :let ausgabe = "\\begin{".umgebung."}{}\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "picture"
   :let ausgabe = "\\begin{".umgebung."}()\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "pspicture"
   :let ausgabe = "\\begin{".umgebung."}()()\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "array"
   :let ausgabe = "\\begin{".umgebung."}[]{}[]\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "table" || umgebung == "figure"
   :let ausgabe = "\\begin{".umgebung."}[]\n\n  \\caption[]{}\n  \\label{}\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "theorem"
   :let ausgabe = "\\begin{".umgebung."}{}[]\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :elseif umgebung == "document"
   :let ausgabe = "\\documentclass[]{}\n\n\\usepackage[]{}\n\n\\begin{".umgebung."}\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :else
   :let ausgabe = "\\begin{".umgebung."}\n\n\\end{".umgebung."}"
   :put!=ausgabe
 :endif
:endfunction

:function! Plain_env()
 :if visualmode() != "V"
   :echo "No text highlighted linewise"
   :return
 :endif
 :let umgebung = input("Enter environment Name: ")
 :if strlen(umgebung) == 0
   :echo "Environment aborted"
   :return
 :elseif umgebung == "itemize" || umgebung == "enumerate" || umgebung == "citemize"
   :let head = "\\begin{".umgebung."}\n  \\item "
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "description" 
   :let head = "\\begin{".umgebung."}\n  \\item[] "
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "minipage"
   :let envoption = input("Enter minipage type for latex209 or latex2e [209, 2e]: ")
   :if envoption == "2e"
     :let head = "\\begin{".umgebung."}[][][]{}\n"
     :let tail = "\n\\end{".umgebung."}"
   :else
     :let head = "\\begin{".umgebung."}[]{}\n"
     :let tail = "\n\\end{".umgebung."}"
   :endif
 :elseif umgebung == "tabular"
   :let head = "\\begin{".umgebung."}[]{}\n"
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "columns"
   :let head = "\\begin{".umgebung."}[]\n"
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "column" || umgebung == "block"
   :let head = "\\begin{".umgebung."}{}\n"
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "picture"
   :let head = "\\begin{".umgebung."}()\n"
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "pspicture"
   :let head = "\\begin{".umgebung."}()()\n"
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "array"
   :let head = "\\begin{".umgebung."}[]{}[]\n"
   :let tail = "\n\\end{".umgebung."}"
 :elseif umgebung == "table" || umgebung == "figure"
   :let head = "\\begin{".umgebung."}[]\n"
   :let tail = "\n  \\caption[]{}\n  \\label{}\n\\end{".umgebung."}"
 :elseif umgebung == "theorem"
   :let head = "\\begin{".umgebung."}{}[]\n"
   :let tail = "\n\\end{".umgebung."}"
 :else
   :let head = "\\begin{".umgebung."}\n"
   :let tail = "\n\\end{".umgebung."}"
 :endif
 :let @m = tail
 :normal `>
 :normal "mp
 :let @m = head
 :normal `<
 :normal "mP
:endfunction

:function! Empty_com()
 :let befehl = input("Enter command Name: ")
 :if strlen(befehl)==0
   :echo "Command aborted"
   :return
 :elseif befehl == "newcommand" || befehl == "renewcommand"
   :let @m = "\\".befehl."{}[]{}"
   :normal "mPhhhh
 :elseif befehl == "multicolumn" 
   :let @m = "\\".befehl."{}{}{}"
   :normal "mPhhhh
 :elseif befehl == "colorbox" || befehl == "textcolor"
   :let @m = "\\".befehl."{}{}"
   :normal "mPhh
 :elseif befehl == "usepackage" ||
     \   befehl == "foilhead" ||
     \   befehl == "includegraphics"
   :let @m = "\\".befehl."[]{}"
   :normal "mPhh
 :elseif befehl == "verb"
   :let @m = "\\".befehl."++"
   :normal "mP
 :else
   :let @m = "\\".befehl."{}"
   :normal "mP
 :endif
:endfunction

:function! Plain_com()
 :if visualmode() != "v"
   :echo "No text highlighted characterwise"
   :return
 :endif
 :let befehl = input("Enter command Name: ")
 :if strlen(befehl)==0
   :echo "Command aborted"
   :return
 :elseif befehl == "newcommand" || befehl == "renewcommand"
   :let head = "\\".befehl."{}[]{"
   :let tail == "}"
 :elseif befehl == "multicolumn" 
   :let head = "\\".befehl."{}{}{"
   :let tail = "}"
 :elseif befehl == "colorbox" || befehl == "textcolor"
   :let head = "\\".befehl."{}{"
   :let tail = "}"
 :elseif befehl == "usepackage" ||
     \   befehl == "foilhead" ||
     \   befehl == "includegraphics"
   :let head = "\\".befehl."[]{"
   :let tail = "}"
 :elseif befehl == "$"
   :let head = "$"
   :let tail = "$"
 :elseif befehl == "\""
   :let head = "\"`"
   :let tail = "\"'"
 :elseif befehl == "'"
   :let head = "``"
   :let tail = "''"
 :elseif befehl == "verb"
   :let head = "\\".befehl."+"
   :let tail = "+"
 :else
   :let head = "\\".befehl."{"
   :let tail = "}"
 :endif
 :let @m = tail
 :normal `>
 :normal "mp
 :let @m = head
 :normal `<
 :normal "mP
:endfunction

:function! LatexUnMenu()
  unmenu &LaTeX
:endfunction

:function! LatexMenu()
menu 8000.10.010 &LaTeX.BibTeXE&ntry.&Article        i@article{,<cr>author = {},<cr>title = {},<cr>year = {},<cr>journal = {},<cr>OPTpages = {},<cr>OPTvolume = {},<cr>OPTmonth = {},<cr>OPTnumber = {}<cr>}<cr>
menu 8000.10.020 &LaTeX.BibTeXE&ntry.B&ook           i@book{,<cr>ALTauthor = {},<cr>ALTeditor = {},<cr>title = {},<cr>year = {},<cr>publisher = {},<cr>OPTaddress = {},<cr>OPTedition = {}<cr>}<cr>
menu 8000.10.020 &LaTeX.BibTeXE&ntry.Bookle&t        i@booklet{,<cr>ALTauthor = {},<cr>title = {},<cr>OPThowpublished = {},<cr>OPTaddress = {},<cr>OPTyear = {},<cr>OPTmonth = {}<cr>}<cr>
menu 8000.10.030 &LaTeX.BibTeXE&ntry.I&nbook         i@inbook{,<cr>ALTauthor = {},<cr>ALTeditor = {},<cr>title = {},<cr>OPTtype = {},<cr>year = {},<cr>publisher = {},<cr>OPTaddress = {},<cr>ALTpages = {},<cr>ALTchapter = {},<cr>OPTedition = {}<cr>}<cr>
menu 8000.10.040 &LaTeX.BibTeXE&ntry.&Incollection   i@incollection{,<cr>author = {},<cr>OPTeditor = {},<cr>title = {},<cr>booktitle = {},<cr>year = {},<cr>publisher = {},<cr>OPTpages = {},<cr>OPTaddress = {},<cr>OPTedition = {}<cr>}<cr>
menu 8000.10.050 &LaTeX.BibTeXE&ntry.Inproce&edings  i@inproceedings{,<cr>author = {},<cr>title = {},<cr>booktitle = {},<cr>year = {},<cr>OPTeditor = {},<cr>OPTvolume = {},<cr>OPTnumber = {},<cr>OPTnumber = {},<cr>OPTseries = {},<cr>OPTpages = {},<cr>OPTaddress = {},<cr>OPTmonth = {},<cr>OPTorganization = {},<cr>OPTpublisher = {},<cr>OPTnote = {}<cr>}<cr>
menu 8000.10.060 &LaTeX.BibTeXE&ntry.Manua&l         i@manual{,<cr>title = {},<cr>OPTauthor = {},<cr>OPTorganization = {},<cr>OPTaddress = {},<cr>OPTedition = {},<cr>OPTmonth = {},<cr>OPTyear = {},<cr>OPTnote = {}<cr>}<cr>
menu 8000.10.070 &LaTeX.BibTeXE&ntry.Masterst&hesis  i@mastersthesis{,<cr>author = {},<cr>title = {},<cr>school = {},<cr>year = {},<cr>OPTtype = {},<cr>OPTaddress = {},<cr>OPTmonth = {},<cr>OPTnote = {}<cr>}<cr>
menu 8000.10.080 &LaTeX.BibTeXE&ntry.Mi&sc           i@misc{,<cr>OPTauthor = {},<cr>OPTtitle = {},<cr>OPThowpublished = {},<cr>OPTmonth = {},<cr>OPTyear = {},<cr>OPTnote = {}<cr>}<cr>
menu 8000.10.090 &LaTeX.BibTeXE&ntry.&Phdthesis      i@phdthesis{,<cr>author = {},<cr>title = {},<cr>school = {},<cr>year = {},<cr>OPTtype = {},<cr>OPTaddress = {},<cr>OPTmonth = {},<cr>OPTnote = {}<cr>}<cr>
menu 8000.10.100 &LaTeX.BibTeXE&ntry.P&roceedings    i@proceedings{,<cr>title = {},<cr>year = {},<cr>OPTeditor = {},<cr>OPTvolume = {},<cr>OPTnumber = {},<cr>OPTseries = {},<cr>OPTaddress = {},<cr>OPTpublisher = {},<cr>OPTnote = {}<cr>OPTmonth = {},<cr>OPTmonth = {},<cr>OPTorganization = {}<cr>}<cr>
menu 8000.10.110 &LaTeX.BibTeXE&ntry.Te&chreport     i@techreport{,<cr>title = {},<cr>author = {},<cr>institution = {},<cr>year = {},<cr>OPTtype = {},<cr>OPTnumber = {},<cr>OPTaddress = {},<cr>OPTmonth = {},<cr>OPTnote = {}<cr>}<cr>
menu 8000.10.120 &LaTeX.BibTeXE&ntry.&Unpublished    i@unpublished{,<cr>author = {},<cr>title = {},<cr>OPTmonth = {},<cr>OPTyear = {},<cr>note = {}<cr>}<cr>
menu 8000.10.900 &LaTeX.-sep1-                       <nul>
vmenu 8000.20     &LaTeX.&Environment\ on\ Region<tab>,ren    <Esc> :call Plain_env()<cr>
nmenu 8000.22     &LaTeX.Empty\ &Environment<tab>,en          :call Empty_env()<cr>
vmenu 8000.25     &LaTeX.&Commands\ on\ Region<tab>,rcm       <Esc> :call Plain_com()<cr>
nmenu 8000.25     &LaTeX.Empty\ &Commands<tab>,cm             :call Empty_com()<cr>
menu 8000.28.010 &LaTeX.-sep2-                       <nul>
menu 8000.40.020 &LaTeX.&Umlaute.Normal\ &TeX        :call Standard_map()<cr>
menu 8000.40.030 &LaTeX.&Umlaute.&No\ mapping        :call Remove_map()<cr>
menu 8000.40.040 &LaTeX.&Umlaute.&German\ TeX\ mapping    :call German_map()<cr>
menu 8000.40.050 &LaTeX.&Umlaute.&BibTeX\ mapping    :call Bibtex_map()<cr>
menu 8000.40.070 &LaTeX.&Umlaute.German\ &Umlaut\ mapping   :call Deutsche_umschreibungen_map()<cr>
menu 8000.50.010 &LaTeX.-sep4-                       <nul>
menu 8000.60     &LaTeX.&LaTeXProject<tab>,la        :call ExeLatex()<cr>
menu 8000.61     &LaTeX.&BibTeXProject               :call ExeBibtex()<cr><Space>
menu 8000.62     &LaTeX.&IndexProject                :call ExeMakeindex()<cr><Space>
menu 8000.70     &LaTeX.&ViewFile<tab>,vi            :call ExeYap()<cr>
menu 8000.75     &LaTeX.&PDFLaTeX                    :call ExePDFLaTeX()<cr>
menu 8000.80     &LaTeX.&dvips                       :call Exedvips()<cr><Space>
menu 8000.83     &LaTeX.&gsview                      :call Exegsv()<cr><Space>
menu 8000.85     &LaTeX.LaTeX\ to\ &HTML             :call Exetohtml()<cr><Space>
menu 8000.90     &LaTeX.Projec&tname<tab>,pr      :call GetProjName()<cr>
endfunction

:function! LatexUnMap()
  unmap ,la
  unmap ,vi
  unmap ,pr
  vunmap ,ren
  unmap ,en
  vunmap ,rcm
  unmap ,cm
:endfunction


:function! LatexMap()
  map ,la     :call ExeLatex()<cr>
  map ,vi     :call ExeYap()<cr>
  map ,pr    :call GetProjName()<cr>
  vmap ,ren  <Esc> :call Plain_env()<cr>
  map ,en   :call Empty_env()<cr>
  vmap ,rcm  <Esc> :call Plain_com()<cr>
  map ,cm   :call Empty_com()<cr>
:endfunction


set timeoutlen=2500
:au BufEnter *.tex,*.dtx,*.ltx,*.bib :call LatexMenu()
:au BufLeave *.tex,*.dtx,*.ltx,*.bib :call LatexUnMenu()
:au BufEnter *.tex,*.dtx,*.ltx,*.bib :call LatexMap()
:au BufLeave *.tex,*.dtx,*.ltx,*.bib :call LatexUnMap()
" :au BufEnter *.tex,*.dtx,*.ltx :call Standard_map()
" :au BufLeave *.tex,*.dtx,*.ltx :call Remove_map()
:au BufEnter *.bib :call Bibtex_map()
:au BufLeave *.bib :call Remove_map()
:au BufEnter *.tex,*.dtx,*.ltx :set isk+=58,46
:au BufLeave *.tex,*.dtx,*.ltx :set isk-=58,46

:au BufEnter *.tex,*.dtx,*.ltx,*.bib :cd %:p:h


" vim:tw=2048 encoding=latin1
