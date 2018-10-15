FILENAME = main.md
BIBLIOGRAPHY = biblio.bib
PANDOC = /usr/bin/pandoc
SLIDES = slides
HANDOUT = handout
LANG = en-GB
BIBLATEXOPTIONS = backend=biber,bibstyle=biblatex-langsci-unified,useprefix=true,doi=false,sortcites=false,mincrossrefs=50,maxbibnames=50
BIBLATEXOPTIONS_BEAMER := $(BIBLATEXOPTIONS),citestyle=langsci-authoryear-comp
BIBLATEXOPTIONS_HANDOUT := $(BIBLATEXOPTIONS),citestyle=verbose,autocite=footnote


RERUN = "(There were undefined references|Rerun to get cross-references right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"

beamer:
	$(PANDOC) \
	--read=markdown \
	--write=beamer \
	--output=$(SLIDES).tex \
	--biblatex \
	--pdf-engine=lualatex \
	--include-in-header=beamer-include.tex \
	--bibliography=$(BIBLIOGRAPHY) \
	--variable=logo:logo.pdf \
	--variable=biblatex:true \
	--variable=biblatexoptions:$(BIBLATEXOPTIONS_BEAMER) \
	--variable=lang:$(LANG) \
	$(FILENAME)

handout:
	$(PANDOC) \
	--read=markdown \
	--write=latex \
	--output=$(HANDOUT).tex \
	--biblatex \
	--number-sections \
	--pdf-engine=lualatex \
	--standalone \
	--include-in-header=include.tex \
	--bibliography=$(BIBLIOGRAPHY) \
	--variable=linkcolor:blue \
	--variable=classoption:nobib \
	--variable=documentclass:tufte-handout \
	--variable=monofont:Iosevka \
	--variable=fontfamily:ebgaramond-maths \
	--variable=lang:$(LANG) \
	--variable=biblatex:true \
	--variable=biblatexoptions:$(BIBLATEXOPTIONS_HANDOUT) \
	$(FILENAME)

beamercompile:
	$(MAKE) beamer
	lualatex $(SLIDES).tex
	egrep -c $(RERUNBIB) $(SLIDES).log && (biber $(SLIDES); lualatex $(SLIDES)) ; true
	egrep -q $(RERUN) $(SLIDES).log && lualatex $(SLIDES)  ; true

handoutcompile:
	$(MAKE) handout
	lualatex $(HANDOUT).tex
	egrep -c $(RERUNBIB) $(HANDOUT).log && (biber $(HANDOUT); lualatex $(HANDOUT)) ; true
	egrep -q $(RERUN) $(HANDOUT).log && lualatex $(HANDOUT)  ; true

all: beamer handout

compileall: beamercompile handoutcompile

clean:
	rm $(HANDOUT).tex $(SLIDES).tex $(HANDOUT).pdf $(SLIDES).pdf *.snm *.log *.aux *.nav *.xml *.bbl *.bcf *.blg *.out *.toc
