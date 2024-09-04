SHELL=/usr/bin/bash
.SILENT:

push:
	git commit -am saving; git push; git status

fail:; sed -i 's/tests-passed-green/tests-failed-red/' README.md
pass:; sed -i 's/tests-failed-red/tests-passed-green/' README.md

test:
	(make run && make pass) || make fail 

watch:
	watch -ctn 2 make test
	
run:
	figlet -W -f small $$RANDOM
	python3 mycode.py

install:
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt  install watch figlet -y