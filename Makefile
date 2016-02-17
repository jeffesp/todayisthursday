# Build site from markdown files markdown in posts dir, written as html to
# output dir using pandoc with template layout.html also builds index of posts
# in reverese order and rss file as well.  copies any files from static/ to
# output

# setup
allposts := $(wildcard posts/*.md)
OUTPUTDIR := output

changeExtension = $(addsuffix $(strip $1), $(basename $2))

# rules
all: site

style: assets/style/normalize.css assets/style/*.scss 
	cat $^ | sassc --style compressed > $(OUTPUTDIR)/site.css

postlist: 
	@$(file >postlist.in, $(sort $(foreach post, $(allposts), $(call changeExtension, .html, $(post)))))

# glorified bash script here...
items: 
	@rm -f items.in
	@head --quiet --lines=5 posts/*.md  | sed -e "s/---//" | tr '\n' ' ' | sed -e "s/\.\.\./\n/g" | sed -e "s/^[ ]*//"  > items.in

index: items.in

posts: posts/*.md
	$(foreach post, $^, pandoc --title-prefix="Today Is Thursday" --template=templates/layout.html $(post) > $(OUTPUTDIR)/$(notdir $(call changeExtension, .html, $(post))))

static: static/*.html
	cp $^ $(OUTPUTDIR)

site: style posts index rss
	cp assets/font/SourceSerifPro.woff output/

regen:
	touch posts/*.md
	make site

clean:
	rm -rf $(OUTPUTDIR)/*
	rm -f postlist.in items.in 

.PHONY: regen postlist site index rss 
