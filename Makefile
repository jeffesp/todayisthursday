
site:
	cp assets/style/normalize.css output/site.css
	node-sass --output-style compressed assets/style/site.scss >> output/site.css
	# TODO: run pandoc on items
	cp index.html output/
	cp about.html output/
	cp assets/font/SourceSerifPro.woff output/

rss:
	# TODO: process items to RSS feed file

clean:
	rm output/*
