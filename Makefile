# Build site from markdown files
# markdown in posts dir, written as html to output dir using pandoc with template layout.html
# also builds index of posts in reverese order and rss file as well.
# copies any files from static/ to output

changeExtension = $(addsuffix $(strip $1), $(notdir $(basename $2)))
allposts := $(wildcard posts/*.md)
OUTPUT := output

all: site

style: assets/style/normalize.css assets/style/*.scss 
	cat $^ | node-sass --output-style compressed > $(OUTPUT)/site.css

postlist: 
	@$(file >postlist.in, $(sort $(foreach post, $(allposts), $(call changeExtension, .html, $(post)))))

index: postlist.in

rss: postlist.in
	@$(foreach post, $(allposts), echo $(call changeExtension, .html, $(post));)

posts: posts/*.md
	$(foreach post, $^, pandoc --title-prefix="Today Is Thursday" --template=templates/layout.html $(post) > $(OUTPUT)/$(call changeExtension, .html, $(post));)


static: static/*.html
	cp $^ $(OUTPUT)

site: style posts index rss
	cp assets/font/SourceSerifPro.woff output/

regen:
	touch posts/*.md
	make site

clean:
	rm -rf output/*

#%.md: %.html
#	pandoc --title-prefix="Today Is Thursday" --template=templates/layout.html $< > $(OUTPUT)/$(call changeExtension, .html, $<)

.PHONY: regen postlist site index rss 
