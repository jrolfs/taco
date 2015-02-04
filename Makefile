docs:
	echo contact ops@mavenlink.com

flynn:
	flynn create mavbot
	cat ~/.mavbot | xargs -I{} flynn env set {}
	git push flynn master
	flynn scale bot=1
