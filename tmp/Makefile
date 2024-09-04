SHELL=/usr/bin/bash

help: ## show help
	grep '^[a-z].*:.*##' $(MAKEFILE_LIST) \
	| sort \
	| gawk 'BEGIN {OSF="\t"; FS="##";print "make [OPTIONS]:\n"} \
	              {printf("%20s %s\n",$$1,$$2)}'

install: ## install cool stuff
	chmod +x mycode.py
	sudo apt -y -qq update  
	sudo apt -y -qq upgrade  
	sudo apt -y -qq install software-properties-common  
	sudo add-apt-repository ppa:deadsnakes/ppa  -y   
	sudo add-apt-repository ppa:ytvwld/asciiquarium -y
	sudo apt -y -qq update  
	sudo apt -y -qq install python3.13 watch figlet asciiquarium cmatrix htop  
	
.SILENT:

asciiquarium: ## have fun
	/usr/games/asciiquarium 

matrix:
	cmatrix -u 7 -b

push: ## save yyour work
	git commit -am saving; git push; git status

failed:; sed -i 's/tests-passed-green/tests-failed-red/' README.md
passed:; sed -i 's/tests-failed-red/tests-passed-green/' README.md

run:
	figlet -W -f small $$RANDOM
	python3 mycode.py

watch: ## watch tests
	watch -ctn 2 make test

test: ## run tests
	(make run && make passed) || make failed 



