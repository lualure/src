ready:
	git config --global user.name "Tim Menzies"
	git config --global user.email tim.menzies@gmail.com
	git config --global credential.helper cache
	git config credential.helper 'cache --timeout=3600'
	git config --global push.default simple

hi: ready
	git push origin master

bye: ready
	git status
	git commit -am "saving"
	git push origin master
