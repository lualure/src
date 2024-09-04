# make files store all your short cuts, your build methods
# notepad for everything you might want to run the future

SHELL=/usr/bin/bash
.SILENT: # tun off all the verbose output .

LOUD=\033[1;33m 
SOFT=\033[0m

# the first rule is the default. just typing "make" calls the default
help :  makehelp pyhelp ## show help

makehelp: # grep for feasture extraction, sort to sort, gawk for report ternum
	grep '^[a-z].*:.*##' $(MAKEFILE_LIST) \
	| sort \
	| gawk 'BEGIN {FS="##"; print "$(LOUD)make$(SOFT) [OPTIONS]"} \
	              { sub(/ .*/,"",$$1); \
				    printf("$(LOUD)%17s$(SOFT) %s\n",$$1,$$2)}'

pyhelp:
	echo  -e "\n$(LOUD)./s.py$(SOFT) -OPTION"
	python3.13 s.py -show

install : ## install cool stuff
    # everyone needs an onstall scriot
	chmod +x s.py
	sudo apt -y -qq update  
	sudo apt -y -qq upgrade  
	sudo apt -y -qq install software-properties-common  
	sudo add-apt-repository ppa:deadsnakes/ppa  -y   
	sudo add-apt-repository ppa:ytvwld/asciiquarium -y
	sudo apt -y -qq update  
	sudo apt -y -qq install python3.13 watch figlet asciiquarium cmatrix htop bsdgames

asciiquarium : ## have fun
	/usr/games/asciiquarium 

robots : ## exxterminate!
	/usr/games/robots

matrix : ## they are coming to get you
	cmatrix -u 7 -b

push : ## save your work
	echo -en "$(LOUD)Why this push? $(SOFT)"; read x; git commit -am "$$x"; git push; git status

# "sed -i" edits "in place". be careful!
failed:; sed -i 's/tests-passed-green/tests-failed-red/' README.md
passed:; sed -i 's/tests-failed-red/tests-passed-green/' README.md

test : ## run tests
	(python3 s.py -all && make passed) || make failed 

watch : ## watch tests
	watch -ctn 2 make test


