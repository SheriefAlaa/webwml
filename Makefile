TORCVSSTABLE = ../tor.0.1.0-branch
TORCVSHEAD = ../tor-head

WMLBASE = .
WMLOPT  = \
          -I include \
          -D DOCROOT=$(WMLBASE) \
          -D IMGROOT=$(WMLBASE)/images \
          -D TORCVSSTABLE=$(TORCVSSTABLE) \
          -D TORCVSHEAD=$(TORCVSHEAD)

WMLFILES=$(wildcard en/*.wml \
                    de/*.wml \
                    it/*.wml \
          )
WMIFILES=$(wildcard include/*.wmi \
                    en/*.wmi      \
                    de/*.wmi      \
                    it/*.wmi      \
          )
HTMLFILES = $(patsubst de/%.wml, %.html.de, \
            $(patsubst en/%.wml, %.html.en, \
            $(patsubst it/%.wml, %.html.it, \
            $(WMLFILES))))
DEPFILES =  $(patsubst de/%.wml,.deps/%.html.de.d,   \
            $(patsubst en/%.wml,.deps/%.html.en.d,   \
            $(patsubst it/%.wml,.deps/%.html.it.d,   \
            $(WMLFILES))))

LANGS=de en it

all: $(HTMLFILES)



%.html.en: en/%.wml
	lang=`dirname $<` && wml $(WMLOPT) -I $$lang -D LANG=$$lang $< -o $@

%.html.de: de/%.wml en/%.wml
	lang=`dirname $<` && wml $(WMLOPT) -I $$lang -D LANG=$$lang $< -o $@

%.html.it: it/%.wml en/%.wml
	lang=`dirname $<` && wml $(WMLOPT) -I $$lang -D LANG=$$lang $< -o $@


.deps/%.html.en.d: en/%.wml
	@[ -d .deps ] || mkdir .deps
	tmpfile=`tempfile` \
	lang=`dirname $<` && \
	OUT=`echo $@ | sed -e 's,\.deps/\(.*\)\.d$$,\1,'` && \
	wml $(WMLOPT) -I $$lang -D LANG=$$lang $< -o $$OUT --depend | tee $$tmpfile > $@ && \
	sed -e s',\(^[^ ]*\):,.deps/\1.d:,' < $$tmpfile >> $@ && \
	rm -f $$tmpfile
.deps/%.html.de.d: de/%.wml
	@[ -d .deps ] || mkdir .deps
	tmpfile=`tempfile` \
	lang=`dirname $<` && \
	OUT=`echo $@ | sed -e 's,\.deps/\(.*\)\.d$$,\1,'` && \
	wml $(WMLOPT) -I $$lang -D LANG=$$lang $< -o $$OUT --depend | tee $$tmpfile > $@ && \
	sed -e s',\(^[^ ]*\):,.deps/\1.d:,' < $$tmpfile >> $@ && \
	rm -f $$tmpfile
.deps/%.html.it.d: it/%.wml
	@[ -d .deps ] || mkdir .deps
	tmpfile=`tempfile` \
	lang=`dirname $<` && \
	OUT=`echo $@ | sed -e 's,\.deps/\(.*\)\.d$$,\1,'` && \
	wml $(WMLOPT) -I $$lang -D LANG=$$lang $< -o $$OUT --depend | tee $$tmpfile > $@ && \
	sed -e s',\(^[^ ]*\):,.deps/\1.d:,' < $$tmpfile >> $@ && \
	rm -f $$tmpfile

tor-manual-cvs.html.en: $(TORCVSHEAD)/doc/tor.1.in
tor-manual.html.en: $(TORCVSSTABLE)/doc/tor.1.in

translation-status.html.en: $(LANGS) $(WMIFILES) $(WMLFILES)

dep: $(DEPFILES)

clean:
	rm -f $(HTMLFILES) $(DEPFILES)

include $(DEPFILES)





# If we choose to use make rather than perl.  gets us proper dependencies, but doesn't
# catch invalid page links that nicely.  Also, this doesn't really work yet, since
# I abandoned this path for the much simplier and more readable <page> tag in
# links.wmi, which just uses 3 lines of perl.
### 
### %.en.html: en/%.wml include-auto/langlocallinks.en.wmi include-auto/locallinks.wmi
### %.de.html: de/%.wml en/%.wml include-auto/langlocallinks.de.wmi include-auto/locallinks.wmi
### %.it.html: it/%.wml en/%.wml include-auto/langlocallinks.it.wmi include-auto/locallinks.wmi
### 
### .deps/%.en.html.d: en/%.wml include-auto/langlocallinks.en.wmi include-auto/locallinks.wmi
### .deps/%.de.html.d: de/%.wml include-auto/langlocallinks.de.wmi include-auto/locallinks.wmi
### .deps/%.it.html.d: it/%.wml include-auto/langlocallinks.it.wmi include-auto/locallinks.wmi
### 
### 
### 
### include-auto/locallinks.wmi: $(LANGS)
### 	files=$$(for i in $^; do ls -1 $$i/*.wml; done | \
### 		xargs -n1 basename | sed -e 's,\.wml,,' | sort | uniq) && \
### 	rm -f $@.tmp && \
### 	echo "<define-tag pageALL whitespace=delete>" > $@.tmp && \
### 	for f in $$files; do \
### 		echo "<define-tag link-$$f whitespace=delete>$$f.html</define-tag>" >> $@.tmp; \
### 	done
### 	if ! [ -z "$$FORCE_LOCALLINKS_UPDATE" ] || ! [ -e "$@" ] || ! diff "$@" "$@".tmp > /dev/null; then \
### 		cat "$@".tmp > "$@"; \
### 	else \
### 		echo "$@ hasn't changed and environment variable FORCE_LOCALLINKS_UPDATE not set"; \
### 	fi
### 	rm -f "$@".tmp
### 
### include-auto/langlocallinks.%.wmi: %
### 	@[ -d include-auto ] || mkdir include-auto
### 	lang=$< \
### 	files=$$(for i in $^; do ls -1 $$i/*.wml; done | \
### 		xargs -n1 basename | sed -e 's,\.wml,,' | sort | uniq) && \
### 	rm -f $@.tmp && \
### 	for f in $$files; do \
### 		echo "<define-tag link-$$f whitespace=delete>$$f.$$lang.html</define-tag>" >> $@.tmp; \
### 	done
### 	if ! [ -z "$$FORCE_LOCALLINKS_UPDATE" ] || ! [ -e "$@" ] || ! diff "$@" "$@".tmp > /dev/null; then \
### 		cat "$@".tmp > "$@"; \
### 	else \
### 		echo "$@ hasn't changed and environment variable FORCE_LOCALLINKS_UPDATE not set"; \
### 	fi
### 	rm -f "$@".tmp
### 
