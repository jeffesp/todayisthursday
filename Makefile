default: clean site

style: assets/style/normalize.css assets/style/*.scss 
	cat $^ | node-sass --output-style compressed > output/site.css

site: style posts rss
	cp index.html output/
	cp about.html output/
	cp assets/font/SourceSerifPro.woff output/

posts: posts/*.md
	for post in $^ ; do \
		pandoc --title-prefix="Today Is Thursday" --include-before-body=templates/header.html --include-after-body=templates/footer.html --template=templates/layout.html $$post > output/`basename -s md $$post`html ; \
	done

rss:
	# TODO: process items to RSS feed file

clean:
	rm -rf output/*
