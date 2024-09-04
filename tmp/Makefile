SHELL=/usr/bin/bash

install:
	sudo apt -y -qq update  
	sudo apt -y -qq upgrade  
	sudo apt -y -qq install software-properties-common  
	sudo add-apt-repository ppa:deadsnakes/ppa  -y   
	sudo add-apt-repository ppa:ytvwld/asciiquarium -y
	sudo apt -y -qq update  
	sudo apt -y -qq install python3.13 watch figlet mceditasciiquarium cmatrix htop  
	
asciiquarium:
	/usr/games/asciiquarium 

#.SILENT:

push:
	git commit -am saving; git push; git status

failed:; sed -i 's/tests-passed-green/tests-failed-red/' README.md
passed:; sed -i 's/tests-failed-red/tests-passed-green/' README.md

test:
	(make run && make passed) || make failed 

watch:
	watch -ctn 2 make test
	
run:
	figlet -W -f small $$RANDOM
	python3 mycode.py


